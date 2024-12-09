data = readlines("data/5.txt")
div = findall(data .== "")[1]

to_int(x) = parse.(Int, x)
rules = to_int.(split.(data[1:(div-1)], "|"))
pages = to_int.(split.(data[(div+1):end], ","))

check_rules(p, rl) = ifelse(
    any([r ⊆ p && !all(p ∩ r .== r) for r in rl]),
    0, p[ceil(Int, end / 2)])

p1 = sum(check_rules.(pages, (rules,)))

println("Part 1: $p1")

rulesort(x, y) = [x, y] in rules
p2 = sum(check_rules.(sort.(pages, lt=rulesort), (rules,))) - p1

println("Part 1: $p2")
