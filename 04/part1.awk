#!awk -f

BEGIN {
    t = 0
}

{
    rows[NR] = $1
}

END {
    for (r = 1; r <= NR; r++) {
        for (c = 1; c <= length(rows[r]); c++) {
            if (substr(rows[r], c, 1) != "@") continue

            cnt = 0
            for (y = r - 1; y <= r + 1; y++) {
                for (x = c - 1; x <= c + 1; x++) {
                    if (x < 1 || x > length(rows[r])) continue
                    if (y < 1 || y > NR) continue
                    if (x == c && y == r) continue
                    if (substr(rows[y], x, 1) == "@") cnt++
                }
            }
            if (cnt < 4) {
                t++
            }
        }
    }

    print t
}
