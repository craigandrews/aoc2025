#!awk -f

BEGIN {
    FS="-"
    t = 0
}

$2 ~ /./ {
    start[NR] = $1
    end[NR] = $2
    num++
}

$1 ~ /./ && $2 == "" {
    f = 0
    for (ix = 1; ix <= num; ix++) {
        if ($1 >= start[ix] && $1 <= end[ix]) {
            f = 1
            break
        }
    }
    if (f == 1) t++
}

END {
    print t
}
