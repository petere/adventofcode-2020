#!/usr/bin/env php
<?php

$file = fopen("input.txt", "r");

if (!$file)
    exit(1);

$all_colors = array();
$contains = array();

function may_contain($outer_color, $inner_color)
{
    global $contains;

    if (array_key_exists($outer_color, $contains)) {
        $inner_colors = array_keys($contains[$outer_color]);
        if (in_array($inner_color, $inner_colors))
            return TRUE;
        else {
            foreach ($inner_colors as $c) {
                if (may_contain($c, $inner_color))
                    return TRUE;
            }
        }
    }
    return FALSE;
}

function count_contains($color)
{
    global $contains;

    $result = 0;

    if (array_key_exists($color, $contains)) {
        foreach ($contains[$color] as $col => $num) {
            $result += $num * (1 + count_contains($col));
        }
    }

    return $result;
}

while(!feof($file)) {
    $line = fgets($file);
    if (!$line)
        continue;

    if (preg_match("/contain no other bags/", $line))
        continue;

    if (!preg_match("/(\w+ \w+) bags contain (.+)\./", $line, $matches1)) {
        echo("parse error: " . $line);
        exit(1);
    }

    foreach (explode(", ", $matches1[2]) as $v) {
        if (!preg_match("/(\d+) (\w+ \w+) bags?/", $v, $matches2)) {
            echo("parse error: " . $line);
            exit(1);
        }

        $outer = $matches1[1];
        $inner = $matches2[2];
        $inner_count = $matches2[1];

        $contains[$outer][$inner] = $inner_count;

        $all_colors[] = $outer;
        $all_colors[] = $inner;
    }
}

$all_colors = array_unique($all_colors);

$count = 0;
foreach($all_colors as $color) {
    if (may_contain($color, "shiny gold"))
        $count++;
}

echo $count, "\n";

// part 2

$count = count_contains("shiny gold");

echo $count, "\n";
