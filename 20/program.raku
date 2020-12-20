#!/usr/bin/env raku

constant $tile_size = 10;

my $contents = slurp 'input.txt';
my @blobs = $contents.split("\n\n", :skip-empty);
my @blobs2 = @blobs.map({ .split("\n", 2) });

my %tiles;

for @blobs2 -> $b {
    my @b = @($b);
    @b[0] ~~ m/\d+/;
    my $tilenum = $/;
    my @arr[10;10];
    my @lines = @b[1].split("\n");
    for 0..9 -> $y {
        my $line = @lines[$y];
        for 0..9 -> $x {
            my @chars = $line.split("");
            @arr[$y;$x] = @chars[$x+1];
        }
    }
    %tiles.push: ($tilenum => @arr);
}

my Int $grid_side = sqrt(%tiles.keys.elems).Int;

# rotate 90 degrees clockwise
sub rotate2d(@arr) {
    my $length = @arr.elems;
    my @newarr[$length; $length];
    for 0..($length-1) -> $x {
        for 0..($length-1) -> $y {
            @newarr[$x; $y] = @arr[$length-$y-1; $x];
        }
    }
    return @newarr;
}

# flip horizontally
sub fliph(@arr) {
    my $length = @arr.elems;
    my @newarr[$length; $length];
    for 0..($length-1) -> $x {
        for 0..($length-1) -> $y {
            @newarr[$x; $y] = @arr[$length-$x-1; $y];
        }
    }
    return @newarr;
}

sub variant($i, @arr) {
    given $i {
        when 0 { @arr }
        when 1 { @arr ==> rotate2d() }
        when 2 { @arr ==> rotate2d() ==> rotate2d() }
        when 3 { @arr ==> rotate2d() ==> rotate2d() ==> rotate2d() }
        when 4..7 { @arr ==> fliph() ==> variant($i - 4) }
    }
}

my %tile_variants;
for %tiles.keys.sort -> $k {
    for 0..7 -> $v {
        %tile_variants{$k}{$v} = variant($v, %tiles{$k});
    }
}

sub tile_fits($tilenum, @all_tiles) {
    my $tile = @all_tiles[$tilenum];
    my $x = $tilenum mod $grid_side;
    my $y = $tilenum div $grid_side;
    my $fits = True;
    # check against tile on left
    if ($tilenum mod $grid_side > 0) {
        $fits &&= tiles_line_up_lr(@all_tiles[$tilenum-1], @all_tiles[$tilenum]);
    }
    # check against tile on right
    if ($tilenum mod $grid_side < $grid_side-1) and ($tilenum+1 < @all_tiles.elems) {
        $fits &&= tiles_line_up_lr(@all_tiles[$tilenum], @all_tiles[$tilenum+1]);
    }
    # check against tile above
    if ($tilenum div $grid_side > 0) {
        $fits &&= tiles_line_up_ud(@all_tiles[$tilenum-$grid_side], @all_tiles[$tilenum]);
    }
    # check against tile below
    if ($tilenum div $grid_side < $grid_side-1) and ($tilenum+$grid_side < @all_tiles.elems) {
        $fits &&= tiles_line_up_ud(@all_tiles[$tilenum], @all_tiles[$tilenum+$grid_side]);
    }
    return $fits;
}

sub tiles_line_up_lr(@left, @right) {
    for 0..$tile_size-1 -> $y {
        if @left[$y; $tile_size-1] ne @right[$y; 0] {
            return False;
        }
    }
    return True;
}

sub tiles_line_up_ud(@up, @down) {
    for 0..$tile_size-1 -> $x {
        if @up[$tile_size-1; $x] ne @down[0; $x] {
            return False;
        }
    }
    return True;
}

my %possible_neighbors;

for %tiles.keys.sort -> $k {
    PAIR: for %tiles.keys.sort -> $o {
        if $k < $o {
            for 0..7 -> $i {
                for 0..7 -> $j {
                    if tile_fits(1, [%tile_variants{$k}{$i}, %tile_variants{$o}{$j}]) {
                        %possible_neighbors{$k}{$o} = True;
                        next PAIR;
                    }
                }
            }
        } elsif $k == $o {
            next;
        } else {
            %possible_neighbors{$k}{$o} = True if %possible_neighbors{$o}{$k};
        }
    }
}

sub find_arrangement(@start, %tiles_left) {
    if %tiles_left.keys.elems == 0 {
        return @start;
    }

    my @poss_next_tiles;
    if @start.elems mod $grid_side != 0 {
        @poss_next_tiles = %possible_neighbors{@start[*-1][1]}.keys;
    } elsif @start.elems div $grid_side > 0 {
        @poss_next_tiles = %possible_neighbors{@start[@start.elems - $grid_side][1]}.keys;
    } else {
        @poss_next_tiles = %tiles_left.keys.sort;
    }

    for @poss_next_tiles -> $k {
        for 0..7 -> $v {
            my @new_start = @start.clone;
            @new_start.push([$v, $k]);
            my %new_tiles = %tiles_left.clone;
            %new_tiles{$k}:delete;

            my @grid = [];
            for @new_start -> @x {
                my $var = @x[0];
                my $tn = @x[1];
                my $g = %tile_variants{$tn}{$var};
                @grid.push($g);
            }
            if tile_fits(@grid.elems-1, @grid) {
                my @res = find_arrangement(@new_start, %new_tiles);
                if (@res.elems == %tiles.keys.elems) {
                    return @res;
                }
            }
        }
    }

    return [];
}

my @match = find_arrangement([], %tiles);
my $prod = @match[0; 1] * @match[$grid_side-1; 1] * @match[($grid_side-1)*$grid_side; 1] * @match[$grid_side*$grid_side-1; 1];

say $prod;

# part 2

my $image_width := ($tile_size - 2) * $grid_side;
my @image[$image_width; $image_width];

my $count_hashes = 0;
for 0..@match.elems-1 -> $i {
    my $var = @match[$i][0];
    my $tn = @match[$i][1];
    my $tile = %tile_variants{$tn}{$var};

    my $base_y = ($tile_size-2) * ($i div $grid_side);
    my $base_x = ($tile_size-2) * ($i mod $grid_side);
    for 1..$tile_size-2 -> $y {
        for 1..$tile_size-2 -> $x {
            @image[$base_y + $y-1; $base_x + $x-1] = $tile[$y; $x];
            $count_hashes++ if $tile[$y; $x] eq "#";
        }
    }
}

sub matches_monster_at(@img, $x, $y) {
    return (@img[$y+1; $x] eq "#"
            && @img[$y+2; $x+1] eq "#"
            && @img[$y+2; $x+4] eq "#"
            && @img[$y+1; $x+5] eq "#"
            && @img[$y+1; $x+6] eq "#"
            && @img[$y+2; $x+7] eq "#"
            && @img[$y+2; $x+10] eq "#"
            && @img[$y+1; $x+11] eq "#"
            && @img[$y+1; $x+12] eq "#"
            && @img[$y+2; $x+13] eq "#"
            && @img[$y+2; $x+16] eq "#"
            && @img[$y+1; $x+17] eq "#"
            && @img[$y+0; $x+18] eq "#"
            && @img[$y+1; $x+18] eq "#"
            && @img[$y+1; $x+19] eq "#");
}

my $count_monsters = 0;
for 0..7 -> $var {
    my $im = variant($var, @image);
    for 0..$image_width-1-2 -> $y {
        for 0..$image_width-1-19 -> $x {
            if matches_monster_at($im, $x, $y) {
                $count_monsters++;
            }
        }
    }
    last if $count_monsters > 0;
}

my $result = $count_hashes - $count_monsters * 15;

say $result;
