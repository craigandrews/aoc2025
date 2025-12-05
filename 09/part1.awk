#!awk -f

BEGIN {
    FS = ","
}

func abs(n) {
    if (n >= 0) return n
    return 0 - n
}

/./ {
    xs[NR] = $1
    ys[NR] = $2
}

END {
    max = 0
    for (a = 1; a <= length(xs); a++) {
        for (b = 1; b < length(xs); b++) {
            if (a == b) continue
            area = (abs(xs[a] - xs[b]) + 1) * (abs(ys[a] - ys[b]) + 1)
            if (area > max) max = area
        }
    }
    print max
}
