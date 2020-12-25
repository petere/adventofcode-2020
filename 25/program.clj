#!/usr/bin/env clojure

(require '[clojure.java.io :as io])

(def filename "input.txt")

(defn one-transform [subj val]
  (mod (* val subj) 20201227))

(defn transform [subj lp]
  (nth (iterate (fn [x] (one-transform subj x)) 1) lp))

(def inputlines
  (with-open [rdr (io/reader filename)]
    (doall
     (line-seq rdr))))

(def card-pubkey (Integer. (first inputlines)))
(def door-pubkey (Integer. (second inputlines)))

(defn find-loop-size [subj pubkey]
  (loop [lp 0
         val 1]
    (if (= val pubkey)
      lp
      (recur (inc lp)
             (one-transform subj val)))))

(println
 (let [card-loop (find-loop-size 7 card-pubkey)
       door-loop (find-loop-size 7 door-pubkey)
       enckey (transform door-pubkey card-loop)]
   enckey))
