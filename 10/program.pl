#!/usr/bin/env perl

use strict;
use warnings;
no warnings 'recursion'; # ;-)
use experimental 'smartmatch';

use List::Util qw(max);

open my $f, '<', 'input.txt' or die;

my @numbers = sort { $a <=> $b } map { int } <$f>;

unshift @numbers, 0;

my @counts;

for (my $i = 1; $i < scalar(@numbers); $i++) {
    $counts[$numbers[$i] - $numbers[$i - 1]]++;
}
$counts[3]++;

print $counts[1] * $counts[3], "\n";

# part 2

my @already_counted = ();

sub count_arrangements
{
    my ($start_jolt) = @_;

    if ($already_counted[$start_jolt]) {
        return $already_counted[$start_jolt];
    }

    if ($start_jolt == max(@numbers)) {
        return 1;
    }

    my $count = 0;
    foreach my $n (1..3) {
        if (($start_jolt + $n) ~~ @numbers) {
            $count += count_arrangements($start_jolt + $n);
        }
    }

    $already_counted[$start_jolt] = $count;
    return $count;
}

print count_arrangements(0), "\n";
