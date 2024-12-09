data = permutedims(reduce(hcat, split.(readlines("data/8.txt"), "")))
side_length = size(data)[1]
antennas = findall(x -> x != ".", data)
nodesp1 = Set{CartesianIndex}()
nodesp2 = Set{CartesianIndex}()

in_bounds(x) = all([i > 0 && i <= side_length for i in Tuple(x)])
gcd_dir(x) = CartesianIndex(x[1] ÷ 2, x[2] ÷ 2)

for loc in CartesianIndices(data)
    for antenna in filter(x -> x != loc, antennas)
        res_antenna = loc + 2 * (antenna - loc)
        if in_bounds(res_antenna) && data[res_antenna] == data[antenna]
            push!(nodesp1, loc)
            dir = gcd_dir(res_antenna - loc)

            cursor1 = loc + dir
            cursor2 = loc - dir

            while in_bounds(cursor1)
                push!(nodesp2, cursor1)
                cursor1 = cursor1 + dir
            end

            while in_bounds(cursor2)
                push!(nodesp2, cursor2)
                cursor2 = cursor2 - dir
            end
        end
    end
end

println("Part 1: $(length(nodesp1))")
println("Part 2: $(length(union(nodesp1, nodesp2, antennas)))")
