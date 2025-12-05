#!gawk -f

BEGIN {
    t = 0
}

/./ {
    l = 0
    lights = 0
    delete switches
    for (ix = 1; ix < NF; ix++) {
        type = substr($ix, 1, 1)
        if (type == "[") {
            l = length($ix) - 2
            for (iy = 1; iy <= l; iy++) {
                lights *= 2
                if (substr($ix, 1+iy, 1) == "#") lights +=  1
            }
        } else if (type == "(") {
            split(substr($ix, 2), b, ",")
            s = 0
            for (iz in b) {
                i = int(b[iz])
                s += 2 ** (l - i - 1)
            }
            switches[length(switches) + 1] = s
        }
    }

    delete q
    delete v
    delete d
    q[1] = 0
    v[0] = 1
    d[0] = 0

    for (ix = 1; ix <= length(q); ix++) {
        state = q[ix]
        dist = d[state]

        for (s in switches) {
            newstate = xor(state, switches[s])

            if (v[newstate] == 1) continue

            v[newstate] = 1
            d[newstate] = dist + 1
            q[length(q)+1] = newstate

            if (newstate == lights) {
                t += dist + 1
                break
            }
        }

        if (newstate == lights) break
    }
}

END {
    print t
}
