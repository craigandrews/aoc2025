#!awk -f

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

func walk(n,   nodes, ix, t) {
    if (n == "out") return 1
    sep(links[n], nodes)
    t = 0
    for (ix = 1; ix <= length(nodes); ix++) {
        t += walk(nodes[ix])
    }
    return t
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

END {
    print walk("you")
}
