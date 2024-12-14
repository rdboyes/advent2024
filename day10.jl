to_int(x) = parse.(Int8, x)

data = permutedims(
    reduce(hcat, to_int.(split.(readlines("data/10.txt"), "")))
)

side_length = size(data)[1]

in_bounds(x) = all([i > 0 && i <= side_length for i in Tuple(x)])

neighbor_dirs = [
    CartesianIndex(0, 1),
    CartesianIndex(0, -1),
    CartesianIndex(1, 0),
    CartesianIndex(-1, 0)
]

using Graphs

c2i = Dict(c => i for (c, i) in zip(CartesianIndices(data), eachindex(data)))

g = DiGraph()

add_vertices!(g, side_length^2)

for point in CartesianIndices(data)
    for n in neighbor_dirs
        if in_bounds(n + point)
            if data[n + point] == data[point] + 1
                add_edge!(g, c2i[point], c2i[n+point])
            end
        end
    end
end

pathsp1 = Bool[]
pathsp2 = Int[]

for (v0, v9) in Iterators.product(
    [c2i[c] for c in (findall(x -> x == 0, data))],
    [c2i[c] for c in (findall(x -> x == 9, data))])

    push!(pathsp1, has_path(g, v0, v9))
    push!(pathsp2, length(collect(all_simple_paths(g, v0, v9))))
end

println(sum(pathsp1))
print(sum(pathsp2))
