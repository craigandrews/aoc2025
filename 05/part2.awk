#! sh

# magic shell script disguised as a no-op awk block
"exec" "sh" "-c" "sort -n | awk -f '$0'" && 0 {}

BEGIN {
    FS="-"
}

$2 ~ /./ && num > 0 {
    if ($1 >= start[num] && $1 <= end[num]) {
        if ($2 > end[num]) {
            end[num] = $2
        }
    } else {
        num++
        start[num] = $1
        end[num] = $2
    }
}

$2 ~ /./ && num == 0 {
    num++
    start[num] = $1
    end[num] = $2
}

END {
    t = 0
    for (ix = 1; ix <= num; ix++) {
        t += (end[ix] - start[ix]) + 1
    }
    print t
}
