#!awk -f

BEGIN {
    FS=","
    t = 0
}

{
    for (ix = 1; ix <= NF; ix++) {
        split($ix,a,"-");
        s = a[1]
        e = a[2]

        # if the start has an odd length, bump to the next even length power of 10
        # e.g. 9_423_546 becomes 10_000_000
        if (length(s) % 2 != 0) s = 10**length(s)

        # if the end has an odd length, drop it to the next lowest odd length power of 10, minus 1
        # e.g. 9_423_546 becomes 1_000_000 - 1 = 999_999
        if (length(e) % 2 != 0) e = 10**(length(e)-1) - 1

        for (x = s; x <= e; x++) {
            l = int(length(x) / 2)
            if (length(x) != l*2) continue
            if (substr(x, 1, l) == substr(x, l+1)) t += x
        }
    }
}

END {
    print t
}
