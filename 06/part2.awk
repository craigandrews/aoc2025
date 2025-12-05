#!awk -f

BEGIN {
    t = 0
}

$1 ~ /[0-9]/ {
    for (ix=1; ix<=length($0); ix++) {
        c = substr($0, ix, 1)
        if (c != " ") {
            transp[ix] = transp[ix] c
        }
    }
}

$1 ~ /[+*]/ {
    for (ix = 1; ix <= NF; ix++) {
        ops[ix] = $ix
    }
}

END {
    ix = 1
    for (o=1; o<=length(ops); o++) {
        op = ops[o]

        st = 0
        if (op == "*") st = 1

        do {
            l = transp[ix]
            ix++

            if (l == "") break

            if (op == "+") {
                st += l
            } else {
                st *= l
            }
        } while (ix <= length(transp))

        t += st
    }
    print t
}

