#!awk -f

BEGIN {
    a = 50
    b = 0
}

/^[LR]/ {
    d=substr($1, 0, 1)
    v=0+substr($1, 2)
    z = a
    if (d == "L") {
        a = a - v
        if (a <= 0) {
            b += -1 * int(a/100)
            if (z > 0) {
                b++
            }
        }
    } else {
        a = a + v
        if (a >= 100) {
            b += int(a/100)
        }
    }
    a = a % 100
    if (a < 0) a += 100
}

END {
    print b
}
