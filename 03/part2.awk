#!awk -f

BEGIN {
    t = 0
    l = 12
}

{
    num = ""
    p = 0
    for (digit = l; digit > 0; digit--) {
        cur = 0
        for (ix = p+1; ix <= length($1) - (digit-1); ix++) {
            d = substr($1, ix, 1) + 0
            if (d > cur) {
                cur = d
                p = ix
            }
        }
        num = num cur
    }
    t += num
}

END {
    print t
}

