as_int(x) = parse.(Int, x)
ci(a, b) = parse(Int, "$a$b")

function apply_op(total, next_op)
    if next_op[1] == '+'
        return +(total, next_op[2])
    elseif next_op[1] == '*'
        return *(total, next_op[2])
    else
        return ci(total, next_op[2])
    end
end

function possibles(l, t, possible_ops)
    println("checking $t")
    op_list = possible_ops == :p1 ?
              Iterators.product(fill(['+', '*'], length(l) - 1)...) :
              Iterators.filter((x -> 'c' in x),
        Iterators.product(fill(['+', '*', 'c'], length(l) - 1)...))

    for ops in op_list
        foldl(apply_op, zip(ops, l[2:end]), init=l[1]) == t && return t
    end
    return 0
end

function solve()
    input = split.(readlines("data/7.txt"), ": ")
    nums = as_int.([split(i[2], " ") for i in input])
    targets = as_int([i[1] for i in input])
    p1 = [possibles(l, t, :p1) for (t, l) in zip(targets, nums)]
    p2 = [possibles(l, t, :p2) for (t, l) in
          zip(targets[p1.==0], nums[p1.==0])]
    return (sum(p1), sum(p2))
end

ans = solve()

println("Part 1: $(ans[1])")
println("Part 2: $(ans[1]+ans[2])")
