#!awk -f

BEGIN {
    a = 50
    b = 0
}

/^[LR]/ {
    d=substr($1, 0, 1)
    v=0+substr($1, 2)
    if (d == "L") {
        a = a - v
    } else {
        a = a + v
    }
    if (a % 100 == 0) {
        b += 1
    }
}

END {
    print b
}
