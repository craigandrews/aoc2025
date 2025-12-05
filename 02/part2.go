package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

type Range struct {
	Start int
	End   int
}

func (r Range) Contains(x int) bool {
	return x >= r.Start && x <= r.End
}

func main() {
	ranges, min, max := parseRanges()

	minLength := int(math.Log10(float64(min)) + 1)
	maxLength := int(math.Log10(float64(max)) + 1)
	if minLength < 2 {
		minLength = 2
	}

	var total int
	seen := map[int]struct{}{}
	for length := minLength; length <= maxLength; length++ {
		for blockLen := 1; blockLen <= length/2; blockLen++ {
			if length%blockLen != 0 {
				continue
			}

			start := exp(blockLen - 1)
			shift := exp(blockLen)
			end := shift - 1

			repeats := length / blockLen

			for x := start; x <= end; x++ {
				v := x
				for range repeats - 1 {
					v = x + (shift * v)
				}

				if v < min {
					continue
				}

				if v > max {
					break
				}

				if _, ok := seen[v]; ok {
					continue
				}

				seen[v] = struct{}{}

				for _, r := range ranges {
					if r.Contains(v) {
						total += v
						break
					}
				}
			}
		}
	}

	fmt.Println(total)
}

func exp(n int) int {
	if n < 0 {
		panic("negative exp")
	}

	if n == 0 {
		return 1
	}

	r := 1
	for ; n > 0; n-- {
		r *= 10
	}
	return r
}

func parseRanges() ([]Range, int, int) {
	input, err := bufio.NewReader(os.Stdin).ReadString('\n')
	if err != nil {
		panic(err)
	}

	rawRanges := strings.Split(input, ",")

	var min, max int

	var ranges []Range
	for _, raw := range rawRanges {
		parts := strings.SplitN(raw, "-", 2)
		start, err := strconv.Atoi(strings.TrimSpace(parts[0]))
		if err != nil {
			panic(err)
		}
		end, err := strconv.Atoi(strings.TrimSpace(parts[1]))
		if err != nil {
			panic(err)
		}
		ranges = append(ranges, Range{
			Start: start,
			End:   end,
		})

		if start < min || min == 0 {
			min = start
		}

		if end > max {
			max = end
		}
	}

	return ranges, min, max
}
