#!awk -f

BEGIN {
    t = 0
}

/x/ {
    split($1, a, "x")
    area = int(a[1]) * int(a[2])

    sum = 0
    for (ix = 2; ix <= NF; ix++) {
        sum += int($ix)
    }

    if (area >= 9 * sum) t++
}

END {
    print t
}
