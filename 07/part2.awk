#!awk -f

func trace(nr, ix,  _k, _c) {
    _k = nr "-" ix
    if (_k in memo) return memo[_k]

    for (_c = null; nr <= length(grid) && _c != "^"; nr++) {
        _c = substr(grid[nr], ix, 1)
    }


    if (_c == "^") {
        memo[_k] = trace(nr, ix-1) + trace(nr, ix+1)
    } else {
        memo[_k] = 1
    }

    return memo[_k]
}

NR == 1 {
    start = index($0, "S")
}

NR > 1 {
    grid[NR-1] = $0
}

END {
    print trace(1, start)
}
