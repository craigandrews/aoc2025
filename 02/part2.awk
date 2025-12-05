#!awk -f

BEGIN {
    FS=","
    t = 0
}

{
    for (ix = 1; ix <= NF; ix++) {
        split($ix,a,"-");
        if (min == 0 || a[1] < min) min = a[1]
        if (a[2] > max) max = a[2]
        starts[ix] = a[1] + 0
        ends[ix] = a[2] + 0
    }

    minlen = length(min)
    if (minlen < 2) minlen = 2
    maxlen = length(max)

    for (l = minlen; l <= maxlen; l++) {
        for (bsize = 1; bsize <= int(l/2); bsize++) {
            if (l % bsize != 0) continue
            repeats = l / bsize

            bstart = 10**(bsize-1)
            shift = 10**bsize
            bend = shift-1

            for (n = bstart; n <= bend; n++) {
                s = n
                for (r = 1; r < repeats; r++) {
                    s = n + (shift * s)
                }

                if (s < min) continue
                if (s > max) break

                if (s in seen) continue
                seen[s] = true

                for (ix = 1; ix <= length(starts); ix++) {
                    if (s >= starts[ix] && s <= ends[ix]) {
                        t += s
                        break
                    }
                }
            }
        }
    }
}

END {
    print t
}

