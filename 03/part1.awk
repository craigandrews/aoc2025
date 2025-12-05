#!awk -f

BEGIN {
    t = 0
    l = 2
}

{
    d1 = 0
    for (ix = 1; ix <= length($1) - (l-1); ix++) {
        d = substr($1, ix, 1) + 0
        if (d > d1) {
            d1 = d
            p = ix
        }
    }
    d2 = 0
    for (ix = p+1; ix <= length($1); ix++) {
        d = substr($1, ix, 1) + 0
        if (d > d2) {
            d2 = d
        }
    }
    t += d1*10 + d2
}

END {
    print t
}
