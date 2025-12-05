#!gawk -f

func sep(s, a) {
    split(s, a, SUBSEP)
}

func join(a,  r, ix, l) {
    r = ""
    for (ix = 1; ix <= length(a); ix++) {
        r = r a[ix]
        if (ix != length(a)) r = r SUBSEP
    }
    return r
}

BEGIN {
    SUBSEP = ","
}

/./ {
    f = substr($1, 1, 3)
    delete t
    for (ix = 2; ix <= NF; ix++) t[ix-1] = $ix
    links[f] = join(t)
}

func topological_order(n,  l, ix) {
    if (seen[n] == 1) return
    seen[n] = 1
    sep(links[n], l)
    for (ix = 1; ix <= length(l); ix++) {
        topological_order(l[ix])
    }
    stack[length(stack)+1] = n
}

END {
    delete stack
    topological_order("svr")

    # start by checking the very first node with the basic state
    # (neither dac nor fft visited)
    dp["svr",0] = 1
    for (ix = length(stack); ix >= 1; ix--) {
        n = stack[ix]

        # for each connected node, determine whether there was a
        # state change, and add the number of ways this node can be reached
        for (s = 0; s <= 3; s++) {
            ways = dp[n,s]
            if (ways == 0) continue

            sep(links[n], l)
            for (iy = 1; iy <= length(l); iy++) {
                v = l[iy]
                s2 = s
                if (v == "fft") s2 = or(s2, 1)
                if (v == "dac") s2 = or(s2, 2)
                dp[v,s2] += ways
            }
        }
    }

    # the answer is the value where the out node is reached via both
    # dac and fft, hence state 3
    print dp["out",3]
}
