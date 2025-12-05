// Package main contains a single program that uses Kruskal's algorithm to solve Advent Of Code problems.
// Note that it does not produce the ideal mesh; it only does enough to satisfy the puzzle requirements.
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

// Node in the network
type Node struct {
	X      int
	Y      int
	Z      int
	Parent *Node
	Length int
}

// NewNode that is a self-contained circuit
func NewNode(x, y, z int) *Node {
	n := &Node{
		X:      x,
		Y:      y,
		Z:      z,
		Length: 1,
	}
	return n
}

// IsRoot returns true if the node's parent is nil
func (n *Node) IsRoot() bool {
	return n.Parent == nil
}

// Root of the circuit the node is part of
func (n *Node) Root() *Node {
	if n.IsRoot() {
		return n
	}
	return n.Parent.Root()
}

// Merge two root nodes to create a combined circuit
func (n *Node) Merge(o *Node) {
	if !n.IsRoot() || !o.IsRoot() {
		panic("cannot merge non-root nodes")
	}
	n.Length += o.Length

	// only root nodes should have a length
	o.Parent = n
	o.Length = 0
}

// String representation of the Node
func (n *Node) String() string {
	if n.Parent != n {
		return fmt.Sprintf("%d,%d,%d", n.X, n.Y, n.Z)
	}
	return fmt.Sprintf("%d,%d,%d %d", n.X, n.Y, n.Z, n.Length)
}

// Pair of nodes that can be connected in a circuit
type Pair [2]*Node

func sq(n int) int {
	return n * n
}

// Weight of the pair (square of distance)
func (e Pair) Weight() int {
	return sq(e[0].X-e[1].X) + sq(e[0].Y-e[1].Y) + sq(e[0].Z-e[1].Z)
}

func toInt(s string) int {
	n, err := strconv.Atoi(s)
	if err != nil {
		panic(err)
	}
	return n
}

func main() {
	var nodes []*Node
	var pairs []Pair

	var ix int
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		txt := scanner.Text()
		if txt == "" {
			continue
		}

		parts := strings.SplitN(txt, ",", 3)
		n := NewNode(
			toInt(parts[0]),
			toInt(parts[1]),
			toInt(parts[2]),
		)
		nodes = append(nodes, n)

		if ix == 0 {
			// can't make pairs with only one node
			ix++
			continue
		}

		for nix := range ix {
			p := Pair{nodes[nix], n}
			pairs = append(pairs, p)
		}

		ix++
	}

	// log at 1000 for the actual run, or at 10 if we're using the test dataset
	logAt := 1000
	if ix < 1000 {
		logAt = 10
	}

	// Sort edges in ascending order of weight so the closest pair is first
	slices.SortFunc(pairs, func(a, b Pair) int {
		wa := a.Weight()
		wb := b.Weight()

		if wa < wb {
			return -1
		}

		if wa > wb {
			return 1
		}

		return 0
	})

	// Connect pairs into networks, avoiding cycles
	for ix := 0; ix < len(pairs); ix++ {
		if ix == logAt {
			// if we hit the part 1 limit, output the product of the longest 3 circuits
			slices.SortFunc(nodes, func(a, b *Node) int {
				return cmp.Compare(b.Length, a.Length)
			})
			fmt.Println("Part 1:", nodes[0].Length*nodes[1].Length*nodes[2].Length)
		}

		a := pairs[ix][0]
		b := pairs[ix][1]

		// figure out which circuits these two are in
		n1 := a.Root()
		n2 := b.Root()

		// same circuit means we would form a cycle, so skip it
		if n1 == n2 {
			continue
		}

		// merge the circuits into one larger circuit
		n1.Merge(n2)

		// if there is only one circuit left, we're done
		if n1.Length == len(nodes) {
			fmt.Println("Part 2:", a.X*b.X)
			break
		}
	}
}
