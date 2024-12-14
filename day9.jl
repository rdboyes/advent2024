using Base: LinkedList
using BenchmarkTools

to_int(x) = parse.(Int, x)
data = to_int(split.(readline("data/9test1.txt"), ""))

function solve(d)
    c1 = 1
    c2 = length(d)
    total = 0
    count = 0

    while true
        if c1 % 2 == 0
            if d[c2] <= d[c1]
                d[c1] -= d[c2]
                new_count = count + d[c2]
                total += (c2 ÷ 2) * sum(count:(new_count-1))
                if d[c1] == 0
                    c1 += 1
                end
                c2 -= 2
                count = new_count
            else
                d[c2] -= d[c1]
                new_count = count + d[c1]
                total += (c2 ÷ 2) * sum(count:(new_count-1))
                c1 += 1
                count = new_count
            end
        else
            new_count = count + d[c1]
            total += (c1 ÷ 2) * sum(count:(new_count-1))
            count = new_count
            c1 += 1
        end
        c1 > c2 && break
    end

    return total
end

solve(copy(data))

using LinkedLists

function solve2(data)
    expanded = LinkedList{Tuple{Union{Missing,Int},Int,Bool}}()

    for (i, e) in enumerate(data)
        push!(expanded, (ifelse((i % 2 != 0), i ÷ 2, missing), e, false))
    end

    while true
        to_move = findlast(x -> !ismissing(x[1]) && x[3] == false, expanded)

        if isnothing(to_move)
            break
        end

        moved_item = expanded[to_move]

        target_loc = findfirst(
            (x -> ismissing(x[1]) && (x[2] >= moved_item[2])),
            expanded[1:(to_move-1)]
        )

        if isnothing(target_loc)
            expanded[to_move] = (moved_item[1], moved_item[2], true)
        elseif expanded[target_loc][2] == moved_item[2]
            expanded[target_loc] = (moved_item[1], moved_item[2], true)
            expanded[to_move] = (missing, moved_item[2], true)
        elseif expanded[target_loc][2] > moved_item[2]
            expanded[to_move] = (missing, moved_item[2], true)
            insert!(expanded, (target_loc + 1),
                (missing, expanded[target_loc][2] - moved_item[2], false))
            expanded[target_loc] = (moved_item[1], moved_item[2], true)
        end
    end
    return expanded
end

function checksum2(ex)
    count = 0
    total = 0
    for g in ex
        new_count = count + g[2]
        if !ismissing(g[1])
            total += g[1] * sum(count:(new_count-1))
        end
        count = new_count
    end
    return total
end

println(checksum2(solve2(data)))
