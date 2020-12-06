#!/usr/bin/env Rscript

f <- file("input.txt")

total <- 0
total2 <- 0

v <- character()
v2 <- character()

for (line in readLines(f)) {
    if (nchar(line) == 0) {
        total <- total + length(v)
        v <- character()
        total2 <- total2 + length(v2)
        v2 <- character()
    }
    chars <- strsplit(line, "")[[1]]
    # Check length of v to know when we are in a new group.  Note that
    # v2 could become empty even within a group.
    v2 <- if (length(v) != 0) intersect(v2, chars) else chars
    v <- union(v, chars)
}

# count last group
total <- total + length(v)
total2 <- total2 + length(v2)

print(total)
print(total2)

close(f)
