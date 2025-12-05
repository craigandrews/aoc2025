#!gawk -f

# This program doesn't solve the problem. It just converts the input lines into
# MathProg models and pipes them into glpk, pulling the result out with grep
# and cut, before adding them all together.

BEGIN {
    t = 0
    SUBSEP = ","
}

func sep(s, a) {
    return split(s, a, SUBSEP)
}

func join(a,  r, ix) {
    r = ""
    for (ix = 1; ix <= length(a); ix++) {
        r = r a[ix]
        if (ix != length(a)) r = r SUBSEP
    }
    return r
}

/./ {
    l = 0
    jolts = ""
    delete switches
    for (ix = 1; ix <= NF; ix++) {
        sep(substr($ix, 2), b)
        l = length(b)
        type = substr($ix, 1, 1)
        if (type == "{") {
            jolts = substr($ix, 2, length($ix) - 2)
        } else if (type == "(") {
            s = substr($ix, 2, length($ix) - 2)
            switches[length(switches) + 1] = s
        }
    }
    sep(jolts, sjolts)

    command = "glpsol -m /dev/stdin | grep RESULT: | cut -f2"


    for (ix = 1; ix <= length(switches); ix++) {
        print "var s" (ix-1) " integer, >= 0;"  |& command
    }

    delete lights
    for (ix in switches) {
        sep(switches[ix], sw)
        for (iy in sw) {
            light = sw[iy] + 1
            if (length(lights[light]) == 0)  {
                lights[light] = "l" (light-1) ": s" (ix-1)
            } else {
                lights[light] = lights[light] " + s" (ix-1)
            }
        }
    }

    sep(jolts, j)
    for (ix in j) {
        lights[ix] = lights[ix] " = " j[ix] ";"
    }

    for (ix in lights) {
        print lights[ix] |& command
    }

    oc = "minimize z: s0"
    for (ix = 1; ix < length(switches); ix++) {
        oc = oc " + s" ix
    }

    print oc ";" |& command
    print "solve;" |& command
    print "printf \"RESULT:\\t%f\\n\", z;" |& command
    print "end;" |& command

    close(command, "to")

    while ((command |& getline line) > 0) {
        t += line
    }
    close(command)
}

END {
    print t
}
