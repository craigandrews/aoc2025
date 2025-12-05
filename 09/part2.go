package main

import (
	"bufio"
	"cmp"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

type Vertex struct {
	X int
	Y int
}

type Pair [2]Vertex

func (p Pair) Area() int {
	return (abs(p[0].X-p[1].X) + 1) * (abs(p[0].Y-p[1].Y) + 1)
}

func toInt(s string) int {
	n, err := strconv.Atoi(s)
	if err != nil {
		panic(err)
	}
	return n
}

func abs(a int) int {
	if a < 0 {
		return -1 * a
	}
	return a
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func main() {
	// read all the vertices
	var vertices []Vertex
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		txt := scanner.Text()
		if txt == "" {
			continue
		}

		parts := strings.SplitN(txt, ",", 2)
		v := Vertex{
			X: toInt(parts[0]),
			Y: toInt(parts[1]),
		}
		vertices = append(vertices, v)
	}

	// cache all the edges
	var pairs []Pair
	for _, a := range vertices {
		for _, b := range vertices {
			pairs = append(pairs, Pair{a, b})
		}
	}

	// sort the edges by area descending
	slices.SortFunc(pairs, func(a, b Pair) int {
		return cmp.Compare(b.Area(), a.Area())
	})

	// the meat of it
	for _, p := range pairs {
		a := p[0]
		b := p[1]

		minX := min(a.X, b.X)
		maxX := max(a.X, b.X)
		minY := min(a.Y, b.Y)
		maxY := max(a.Y, b.Y)

		// check every edge for intersection
		ok := true
		for ix, c := range vertices {
			iy := (ix + 1) % len(vertices)
			d := vertices[iy]

			minVX := min(c.X, d.X)
			maxVX := max(c.X, d.X)
			minVY := min(c.Y, d.Y)
			maxVY := max(c.Y, d.Y)

			if minVX == maxVX {
				// vertical
				if minVX <= minX || minVX >= maxX {
					// x is outside the rectangle so no intersection
					continue
				}
				if (minVY <= minY && maxVY > minY) || (minVY < maxY && maxVY >= maxY) {
					// crosses the top or bottom edge of the rectangle
					ok = false
					break
				}
			} else {
				// horizontal
				if minVY <= minY || minVY >= maxY {
					// y is outside the rectangle so no intersection
					continue
				}
				if (minVX <= minX && maxVX > minX) || (minVX < maxX && maxVX >= maxX) {
					// crosses the left or right edge of the rectangle
					ok = false
					break
				}
			}
		}

		if ok {
			// if any intersection, stop
			fmt.Println(p.Area())
			break
		}
	}
}
