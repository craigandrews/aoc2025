#!gawk -f

BEGIN {
    FS=","
}

/./ {
    # x, y and z coords
    xs[NR] = $1
    ys[NR] = $2
    zs[NR] = $3

    # parents (storing networks and detecting cycles)
    ps[NR] = NR

    # lengths of networks
    ls[NR] = 1
}

NR > 1 && /./ {
    # deltas between this and every preceding node
    # the key always has the smaller index first
    for (ix = 1; ix < NR; ix++) {
        ds[ix "," NR] = (xs[NR]-xs[ix])**2 + (ys[NR]-ys[ix])**2 + (zs[NR]-zs[ix])**2
    }
}

func delta_compare(i1, v1, i2, v2) {
    if (v1 < v2) return -1
    if (v1 > v2) return 1
    return 0
}

func inverse_compare(i1, v1, i2, v2) {
    if (v1 < v2) return 1
    if (v1 > v2) return -1
    return 0
}

func find_parent(ix) {
    if (ps[ix] == ix) return ix
    return find_parent(ps[ix])
}

END {
    asorti(ds, sds, "delta_compare")

    for (ix = 1; ix <= length(ds); ix++) {
        split(sds[ix], a, ",")

        from = a[1]
        to = a[2]

        fp = find_parent(from)
        tp = find_parent(to)

        if (fp == tp) continue

        ps[tp] = ps[fp]
        ls[fp] += ls[tp]
        delete ls[tp]

        if (length(ls) == 1) {
            print xs[from]*xs[to]
            break
        }
    }
}
