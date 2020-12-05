// read input from stdin:
// swift program.swift < input.txt

var highest = 0
var occupied = Set<Int>()

while let line = readLine() {
    let arr = Array(line.unicodeScalars)

    var row = 0
    for n in 0...6 {
        row *= 2
        if arr[n] == "B" {
            row += 1
        }
    }

    var col = 0
    for n in 0...2 {
        col *= 2
        if arr[n + 7] == "R" {
            col += 1
        }
    }

    let sid = row * 8 + col
    highest = sid > highest ? sid : highest
    occupied.insert(sid)
}

print(highest)

// part 2

for s in 0...highest {
    if !occupied.contains(s) && occupied.contains(s - 1) && occupied.contains(s + 1) {
        print(s)
    }
}
