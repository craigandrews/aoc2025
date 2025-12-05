#!awk -f

func set_beam(ix) {
    row = substr(row, 1, ix-1) "|" substr(row, ix+1)
}

BEGIN {
    t = 0
}

NR == 1 {
    prev = $0
}

NR > 1 {
    row = $0

    for (ix=1; ix<=length(row); ix++) {
        pc = substr(prev, ix, 1)

        if (pc != "|" && pc != "S") continue

        c = substr(row, ix, 1)
        if (c == "^") {
            set_beam(ix-1)
            set_beam(ix+1)
            t++
        } else {
            set_beam(ix)
        }
    }

    prev = row
}

END {
    print t
}
