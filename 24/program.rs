use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead};

fn main() {
    let mut black_tiles: HashSet<(i32, i32)> = HashSet::new();

    if let Ok(file) = File::open("input.txt") {
        for line in io::BufReader::new(file).lines() {
            if let Ok(ok_line) = line {
                let pos = walk_line(&ok_line, (0, 0));
                if black_tiles.contains(&pos) {
                    black_tiles.remove(&pos);
                } else {
                    black_tiles.insert(pos);
                }
            }
        }
    }

    println!("{}", black_tiles.len());

    // part 2

    let mut new_tiles = black_tiles;
    for _day in 1..101 {
        new_tiles = flip_exhibit(new_tiles);
    }

    println!("{}", new_tiles.len());
}

fn walk_line(line: &str, pos: (i32, i32)) -> (i32, i32) {
    if line.is_empty() {
        return pos;
    }

    let (mut x, mut y) = pos;
    let mut chars = line.chars();
    let char1 = chars.next().unwrap();
    if char1 == 's' {
        let char2 = chars.next().unwrap();
        if char2 == 'e' {
            if y % 2 != 0 {
                x += 1;
            }
            y += 1;
        } else if char2 == 'w' {
            if y % 2 == 0 {
                x -= 1;
            }
            y += 1;
        }
        return walk_line(&line[2..], (x, y));
    } else if char1 == 'n' {
        let char2 = chars.next().unwrap();
        if char2 == 'e' {
            if y % 2 != 0 {
                x += 1;
            }
            y -= 1;
        } else if char2 == 'w' {
            if y % 2 == 0 {
                x -= 1;
            }
            y -= 1;
        }
        return walk_line(&line[2..], (x, y));
    } else if char1 == 'e' {
        x += 1;
        return walk_line(&line[1..], (x, y));
    } else if char1 == 'w' {
        x -= 1;
        return walk_line(&line[1..], (x, y));
    } else {
        panic!("invalid line");
    }
}

fn flip_exhibit(old_tiles: HashSet<(i32, i32)>) -> HashSet<(i32, i32)> {
    let mut new_tiles: HashSet<(i32, i32)> = HashSet::new();

    let minx = old_tiles.iter().map(|(x,_)| x).min().unwrap();
    let maxx = old_tiles.iter().map(|(x,_)| x).max().unwrap();
    let miny = old_tiles.iter().map(|(_,y)| y).min().unwrap();
    let maxy = old_tiles.iter().map(|(_,y)| y).max().unwrap();

    for x in minx-1 .. maxx+2 {
        for y in miny-1 .. maxy+2 {
            let c = neighbors((x, y)).iter().filter(|p| old_tiles.contains(p)).count();
            if old_tiles.contains(&(x, y)) {
                if c == 1 || c == 2 {
                    new_tiles.insert((x, y));
                }
            } else {
                if c == 2 {
                    new_tiles.insert((x, y));
                }
            }
        }
    }

    return new_tiles;
}

fn neighbors(pos: (i32, i32)) -> [(i32, i32); 6] {
    let (x, y) = pos;
    if y % 2 == 0 {
        return [ (x+1, y), (x, y+1), (x-1, y+1), (x-1, y), (x-1, y-1), (x, y-1) ];
    } else {
        return [ (x+1, y), (x+1, y+1), (x, y+1), (x-1, y), (x, y-1), (x+1, y-1) ];
    }
}
