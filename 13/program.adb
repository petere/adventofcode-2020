with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
with GNAT.String_Split;

procedure Program is
    Input : File_Type;
begin
    Open (File => Input, Mode => In_File, Name => "input.txt");
    declare
        Line1 : String := Get_Line (Input);
        T : Integer := Integer'Value (Line1);
        Line2 : String := Get_Line (Input);
        Subs : GNAT.String_Split.Slice_Set;
        Min_Wait : Integer := T;
        Min_Bus : Integer;
    begin
        GNAT.String_Split.Create (S          => Subs,
                                  From       => Line2,
                                  Separators => ",",
                                  Mode       => GNAT.String_Split.Multiple);

        for I in 1 .. GNAT.String_Split.Slice_Count (Subs) loop
            declare
                Sub : constant String := GNAT.String_Split.Slice (Subs, I);
            begin
                if Sub = "x" then
                    goto Continue;
                end if;
                declare
                    Bus : Integer := Integer'Value (Sub);
                    Wait : Integer := Bus - (T rem Bus);
                begin
                    if Wait < Min_Wait then
                        Min_Wait := Wait;
                        Min_Bus := Bus;
                    end if;
                end;
            end;
            <<Continue>>
        end loop;
        Put (Min_Wait * Min_Bus);
        New_Line;

        -- part 2

        declare
            Num_Busses : Integer := Integer (GNAT.String_Split.Slice_Count (Subs));
            type Busses_Array is array (0 .. Num_Busses - 1) of Integer;
            Busses : Busses_Array;
        begin
            for I in 1 .. GNAT.String_Split.Slice_Count (Subs) loop
                declare
                    Sub : constant String := GNAT.String_Split.Slice (Subs, I);
                    Index : Integer := Integer(I) - 1;
                begin
                    if Sub = "x" then
                        Busses(Index) := 0;
                    else
                        Busses(Index) := Integer'Value (Sub);
                    end if;
                end;
            end loop;

            declare
                TT : Long_Integer := Long_Integer(0);
                Step : Long_Integer := Long_Integer(1);
                Matches : Boolean;
            begin
                loop
                    Matches := True;
                    for I in 0 .. Num_Busses - 1 loop
                        if Busses(I) /= 0 then
                            if (TT + Long_Integer(I)) rem Long_Integer(Busses(I)) = 0 then
                                if Step mod Long_Integer(Busses(I)) /= 0 then
                                    Step := Step * Long_Integer(Busses(I));
                                end if;
                            else
                                Matches := False;
                            end if;
                        end if;
                        exit when not Matches;
                    end loop;
                    exit when Matches;
                    TT := TT + Step;
                end loop;
                Put_Line (Long_Integer'Image(TT));
            end;
        end;
    end;
end Program;
