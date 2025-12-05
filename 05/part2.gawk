#!gawk -f

func range_sort(i1, v1, i2, v2) {
    if (start[i1] < start[i2]) return -1
    if (start[i1] > start[i2]) return 1
    return 0
}

BEGIN {
    FS="-"
}

$2 ~ /./ {
    num++
    start[num] = $1
    end[num] = $2
}

END {
    asort(start, sstart, "range_sort")
    asort(end, send, "range_sort")

    c = 1
    for (ix = 2; ix <= num; ix++) {
        if (sstart[ix] >= sstart[c] && sstart[ix] <= send[c]) {
            if (send[ix] > send[c]) {
                send[c] = send[ix]
            }
            delete sstart[ix]
            delete send[ix]
        } else {
            c = ix
        }
    }

    t = 0
    for (ix in sstart) {
        t += (send[ix] - sstart[ix]) + 1
    }
    print t
}

