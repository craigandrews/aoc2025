#!awk -f

BEGIN {
    FS = ","
    SUBSEP = ","
}

func abs(a) {
    if (a < 0) return -1 * a
    return a
}

func min(a, b) {
    if (a < b) return a
    return b
}

func max(a, b) {
    if (a > b) return a
    return b
}

/./ {
    nr++
    xs[nr] = $1
    ys[nr] = $2
}

END {
    result = 0

    for (a = 1; a <= nr; a++) {
        for (b = 1; b <= nr; b++) {
            if (a == b) continue

            area = (abs(xs[a] - xs[b]) + 1) * (abs(ys[a] - ys[b]) + 1)
            if (area <= result) continue

            ok = 1

            minx = min(xs[a], xs[b])
            maxx = max(xs[a], xs[b])
            miny = min(ys[a], ys[b])
            maxy = max(ys[a], ys[b])

            for (c = 1; c <= nr; c++) {
                d = c % nr + 1
                minvx = min(xs[c], xs[d])
                maxvx = max(xs[c], xs[d])
                minvy = min(ys[c], ys[d])
                maxvy = max(ys[c], ys[d])
                if (minvx == maxvx) {
                    # vertical
                    if (minvx <= minx || minvx >= maxx) continue
                    if ((minvy <= miny && maxvy > miny) || (minvy < maxy && maxvy >= maxy)) {
                        ok = 0
                        break
                    }
                } else {
                    # horizontal
                    if (minvy <= miny || minvy >= maxy) {
                        continue
                    }
                    if ((minvx <= minx && maxvx > minx) || (minvx < maxx && maxvx >= maxx)) {
                        ok = 0
                        break
                    }
                }
            }

            if (ok == 1) {
                result = area
            }
        }
    }
    print result
}

