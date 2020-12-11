package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
)

func adjacent_seat_nums(pos int, length int, width int) []int {
	height := (length + 1) / width
	x := pos % width
	y := pos / width
	var result []int

	// NW
	if y > 0 && x > 0 {
		result = append(result, pos-width-1)
	}
	// N
	if y > 0 {
		result = append(result, pos-width)
	}
	// NE
	if y > 0 && x < width-1 {
		result = append(result, pos-width+1)
	}
	// W
	if x > 0 {
		result = append(result, pos-1)
	}
	// E
	if x < width-1 {
		result = append(result, pos+1)
	}
	// SW
	if y < height-1 && x > 0 {
		result = append(result, pos+width-1)
	}
	// S
	if y < height-1 {
		result = append(result, pos+width)
	}
	// SE
	if y < height-1 && x < width-1 {
		result = append(result, pos+width+1)
	}

	return result
}

func visible_seat_nums(pos int, seats []rune, width int) []int {
	length := len(seats)
	height := (length + 1) / width
	x := pos % width
	y := pos / width
	var result []int

	// NW
	for i, j := x-1, y-1; i >= 0 && j >= 0; i, j = i-1, j-1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}
	// N
	for i, j := x, y-1; j >= 0; j = j - 1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}
	// NE
	for i, j := x+1, y-1; i < width && j >= 0; i, j = i+1, j-1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}
	// W
	for i, j := x-1, y; i >= 0; i = i - 1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}
	// E
	for i, j := x+1, y; i < width; i = i + 1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}
	// SW
	for i, j := x-1, y+1; i >= 0 && j < height; i, j = i-1, j+1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}
	// S
	for i, j := x, y+1; j < height; j = j + 1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}
	// SE
	for i, j := x+1, y+1; i < width && j < height; i, j = i+1, j+1 {
		if seats[j*width+i] != '.' {
			result = append(result, j*width+i)
			break
		}
	}

	return result
}

func print_seats(seats []rune, width int) {
	for i, s := range seats {
		fmt.Printf("%c", s)
		if (i+1)%width == 0 {
			fmt.Print("\n")
		}
	}
	fmt.Print("\n")
}

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	reader := bufio.NewReader(file)
	var seats []rune
	var width int
	for {
		var line string
		line, err = reader.ReadString('\n')
		if err != nil && err != io.EOF {
			log.Fatal(err)
		}
		if err == io.EOF {
			break
		}
		runes := []rune(line)
		if runes[len(runes)-1] == '\n' {
			runes = runes[:len(runes)-1]
		}
		seats = append(seats, runes...)
		width = len(runes)
	}

	seats0 := seats

	for {
		new_seats := make([]rune, len(seats))
		copy(new_seats, seats)
		for i, s := range seats {
			a := adjacent_seat_nums(i, len(seats), width)
			count_occ := 0
			for _, k := range a {
				if seats[k] == '#' {
					count_occ++
				}
			}
			if s == 'L' && count_occ == 0 {
				new_seats[i] = '#'
			} else if s == '#' && count_occ >= 4 {
				new_seats[i] = 'L'
			} else {
				new_seats[i] = seats[i]
			}
		}
		equal := true
		for i := 0; i < len(seats); i++ {
			if seats[i] != new_seats[i] {
				equal = false
				break
			}
		}
		seats = new_seats
		if equal {
			break
		}
	}

	count := 0
	for _, s := range seats {
		if s == '#' {
			count++
		}
	}
	fmt.Printf("%v\n", count)

	// part 2

	seats = seats0
	for {
		new_seats := make([]rune, len(seats))
		copy(new_seats, seats)
		for i, s := range seats {
			a := visible_seat_nums(i, seats, width)
			count_occ := 0
			for _, k := range a {
				if seats[k] == '#' {
					count_occ++
				}
			}
			if s == 'L' && count_occ == 0 {
				new_seats[i] = '#'
			} else if s == '#' && count_occ >= 5 {
				new_seats[i] = 'L'
			} else {
				new_seats[i] = seats[i]
			}
		}
		equal := true
		for i := 0; i < len(seats); i++ {
			if seats[i] != new_seats[i] {
				equal = false
				break
			}
		}
		seats = new_seats
		if equal {
			break
		}
	}

	count = 0
	for _, s := range seats {
		if s == '#' {
			count++
		}
	}
	fmt.Printf("%v\n", count)
}
