#!/usr/bin/env scala

val input = "496138527"

def play(incups: Array[Int], moves: Int): Array[Int] = {
  var cups = incups
  var current = 0
  var newcups1 = Array.fill[Int](cups.length)(0)
  var newcups2 = Array.fill[Int](cups.length)(0)
  var newcups = newcups1

  for (move <- 1 to moves) {
    //println("-- move " + move + " --")
    //println("cups: " + cups.mkString)
    //println("current: " + cups(current))

    val x1 = (current + 1) % cups.length
    val x2 = (current + 2) % cups.length
    val x3 = (current + 3) % cups.length
    //println("pick up: " + cups(x1) + " " + cups(x2) + " " + cups(x3))

    var destval = cups(current) - 1
    if (destval <= 0) {
      destval += cups.length
    }
    while (destval == cups(x1) || destval == cups(x2) || destval == cups(x3)) {
      destval -= 1
      if (destval <= 0) {
        destval += cups.length
      }
    }
    //println("destination: " + destval)

    var i = current
    var j = current
    var written = 0
    do {
      if (i >= cups.length) {
        i -= cups.length
      }
      if (j >= cups.length) {
        j -= cups.length
      }
      if (i == x1) {
        i += 3
      } else if (cups(i) == destval) {
        newcups(j) = destval
        newcups((j+1) % cups.length) = cups(x1)
        newcups((j+2) % cups.length) = cups(x2)
        newcups((j+3) % cups.length) = cups(x3)
        written += 4
        i += 1
        j += 4
      } else {
        newcups(j) = cups(i)
        written += 1
        i += 1
        j += 1
      }
    } while (written < cups.length)

    cups = newcups
    current = (current + 1) % cups.length

    if (newcups == newcups1) {
      newcups = newcups2
    } else {
      newcups = newcups1
    }
  }

  //println("-- final --")
  //println(cups.mkString)

  return cups
}

val cups = input.toArray.map(x => { x.asDigit })
val res = play(cups, 100)
val fin = res.mkString
val i = fin indexOf "1"
val result = fin.substring(i+1) + fin.slice(0, i)
println(result)

// part 2

val cups2 = cups ++ Range(cups.length + 1, 1 + 1_000_000)
val res2 = play(cups2, 10_000_000)
val i2 = res2 indexOf 1
val v1 = res2((i2 + 1) % cups2.length)
val v2 = res2((i2 + 2) % cups2.length)
println(s"$v1 * $v2 = ${v1.toLong * v2.toLong}")
