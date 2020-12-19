#!/usr/bin/env ocaml

#load "str.cma";;

(* first a bunch of library stuff from Stack Overflow *)

(* https://stackoverflow.com/questions/5774934/how-do-i-read-in-lines-from-a-text-file-in-ocaml *)
let read_file filename =
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines

(* https://stackoverflow.com/questions/31279920/finding-an-item-in-a-list-and-returning-its-index-ocaml *)
let rec find_helper x lst c = match lst with
  | [] -> raise(Not_found)
  | hd::tl -> if (hd=x) then c else find_helper x tl (c+1)

let find x lst = find_helper x lst 0

(* https://stackoverflow.com/questions/2710233/how-to-get-a-sub-list-from-a-list-in-ocaml *)
let rec sublist list i j =
  if i > j then
    []
  else
    (List.nth list i) :: (sublist list (i+1) j)

(* https://stackoverflow.com/questions/53723304/library-function-to-set-nth-element-of-a-list *)
let set_elem i x l =
  List.mapi (fun i' el -> if i = i' then x else el) l

(* my own stuff begins here *)

let rule_number x = int_of_string (List.nth x 0)

(* strip of rule number, sort by rule number, split each rule on space *)
let arrange_rules rules =
  List.map
    (fun x -> Str.split (Str.regexp " ") x)
    (List.map (fun x -> List.nth x 1)
       (List.sort
          (fun a b -> compare (rule_number a) (rule_number b))
          (List.map (fun x -> Str.split (Str.regexp ": ") x) rules)))

let rec string_prefix_matches_rule str rule all_rules =
  match rule with
    [a] -> if (String.get a 0) == '"' then
             begin
               if (String.get a 1) == (String.get str 0) then
                 1
               else
                 -1
             end
           else
             string_prefix_matches_rule_num str (int_of_string a) all_rules
  | [a; "|"; b] -> let v1 = string_prefix_matches_rule str (a::[]) all_rules in
                   if v1 > 0 then
                     v1
                   else
                     string_prefix_matches_rule str (b::[]) all_rules
  | [a; b; "|"; c; d] -> let v1 = string_prefix_matches_rule str (a::b::[]) all_rules in
                         if v1 > 0 then
                           v1
                         else
                           string_prefix_matches_rule str (c::d::[]) all_rules
  | a::rest -> let ra = string_prefix_matches_rule_num str (int_of_string a) all_rules in
               if ra > 0 && ra < (String.length str) then
                 let rr = string_prefix_matches_rule (Str.string_after str ra) rest all_rules in
                 if rr > 0 then
                   ra + rr
                 else
                   -1
               else
                 -1
  | _ -> raise (Failure "invalid rule")
and string_prefix_matches_rule_num str num all_rules =
  let my_rule = List.nth all_rules num in
  if List.mem (string_of_int num) my_rule then
    (* special handling of (some) recursive rules *)
    match my_rule with
      [a; "|"; b; c] when a = b && c = string_of_int num
      -> let v1 = string_prefix_matches_rule_num str (int_of_string a) all_rules in
         if v1 > 0 then
           begin
             if v1 < (String.length str) then
               let v2 = string_prefix_matches_rule_num (Str.string_after str v1) num all_rules in
               if v2 > 0 then
                 v1 + v2
               else
                 v1
             else
               v1
           end
         else
           -1
    | [a; b; "|"; c; d; e] when a = c && b = e && d = string_of_int num
      -> let v1 = string_prefix_matches_rule_num str (int_of_string a) all_rules in
         if v1 > 0 then
           begin
             if v1 < (String.length str) then
               let v2 = string_prefix_matches_rule_num (Str.string_after str v1) num all_rules in
               if v2 > 0 then
                 begin
                   if (v1 + v2) < (String.length str) then
                     let v3 = string_prefix_matches_rule_num (Str.string_after str (v1 + v2)) (int_of_string b) all_rules in
                     if v3 > 0 then
                       v1 + v2 + v3
                     else
                       -1
                   else
                     -1
                 end
               else
                 let v3 = string_prefix_matches_rule_num (Str.string_after str v1) (int_of_string b) all_rules in
                 if v3 > 0 then
                   v1 + v3
                 else
                   -1
             else
               -1
           end
         else
           -1
    | _ -> raise (Failure "unsupported recursive rule")
  else
    string_prefix_matches_rule str my_rule all_rules

let whole_string_matches_rule_num str num all_rules =
  let p = string_prefix_matches_rule_num str num all_rules in
  (p == String.length str)

(* Part 2 recursive rules: Since rule 8 is a prefix of rule 11, we
   can't just run 8 to completion and then match 11. We'd have to do
   some kind of backtracking. As a hack, try all possible ways to
   split the string in two and match 8 and 11 against the parts. *)
let whole_string_matches_8_11_split str split_point all_rules =
  whole_string_matches_rule_num (Str.string_before str split_point) 8 all_rules &&
    whole_string_matches_rule_num (Str.string_after str split_point) 11 all_rules

let whole_string_matches_8_11 str all_rules =
  List.exists
    (fun split -> whole_string_matches_8_11_split str split all_rules)
    (List.init ((String.length str)-1) (fun x -> x + 1))
;;

let lines = read_file "input.txt" in
let empty_line = find "" lines in
let rules = arrange_rules (sublist lines 0 (empty_line - 1)) in
let messages = sublist lines (empty_line + 1) ((List.length lines) - 1) in
Printf.printf "%d\n" (List.length (List.filter (fun m -> whole_string_matches_rule_num m 0 rules) messages));
let new_rules = (set_elem 8 ["42"; "|"; "42"; "8"] (set_elem 11 ["42"; "31"; "|"; "42"; "11"; "31"] rules)) in
Printf.printf "%d\n" (List.length (List.filter (fun m -> whole_string_matches_8_11 m new_rules) messages));
