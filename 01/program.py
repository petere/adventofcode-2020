#!/usr/bin/env python3

import sys

with open(sys.argv[1]) as f:
    content = f.read().splitlines()

numbers = [int(x) for x in content]

for x in numbers:
    for y in numbers:
        if x + y == 2020:
            print(x, y, x * y)

for x in numbers:
    for y in numbers:
        for z in numbers:
            if x + y + z == 2020:
                print(x, y, z, x * y * z)
