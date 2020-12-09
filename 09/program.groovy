#!/usr/bin/env groovy

file = new File("input.txt")
numbers = file.readLines().collect { it as long }

for (i = 25; i < numbers.size(); i++) {
    boolean found = false
    out:
    for (j = i - 25; j < i - 1; j++) {
        for (k = j + 1; k < i; k++) {
            if (numbers[j] + numbers[k] == numbers[i]
                && numbers[j] != numbers[k]) {
                found = true
                break out
            }
        }
    }
    if (!found) {
        println numbers[i]
        faulty_pos = i
        break
    }
}

// part 2

out:
for (i = 0; i < faulty_pos - 1; i++) {
    for (j = i + 1; j < faulty_pos; j++) {
        slice = numbers[i..j].toList()
        if (slice.value.sum() == numbers[faulty_pos]) {
            println slice.value.min() + slice.value.max()
            break out
        }
    }
}
