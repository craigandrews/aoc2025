#!awk -f

BEGIN {
    t = 0
}

$1 ~ /[0-9]/ {
    for (ix = 1; ix <= NF; ix++) {
        if (!(ix in products)) {
            products[ix] = 1
        }

        sums[ix] += $ix
        products[ix] *= $ix
    }
}

$1 ~ /[+*]/ {
    for (ix = 1; ix <= NF; ix++) {
        if ($ix == "+") {
            t += sums[ix]
        } else {
            t += products[ix]
        }
    }
}

END {
    print t
}
