using TidierStrings

text = readlines("data/4.txt")
nl = length(text)
ts = split.(text, "")

fb = text
ud = reduce(*, reduce(hcat, ts), dims = 2)
diag1 = [[ts[x][y] for (x, y) in Iterators.product(1:nl, 1:nl) if x + y == z] for z in 2:(nl*2)]
diag2 = [[ts[x][y] for (x, y) in Iterators.product(1:nl, 1:nl) if x - y == z]
    for z in (nl-1):-1:(-(nl-1))]

function str_count_overlap(column, pattern::Union{String,Regex}; overlap::Bool=false)
    if ismissing(column)
        return (column)
    end

    if pattern isa String
        pattern = Regex(pattern) # treat pattern as regular expression
    end

    # Count the number of matches for the regular expression
    return length(collect(eachmatch(pattern, column, overlap = overlap)))
end

p1 = sum(vcat(
    str_count_overlap.(text, "XMAS|SAMX", overlap=true),
    str_count_overlap.(ud, "XMAS|SAMX", overlap=true),
    str_count_overlap.(map(x -> *(x...), diag1), "XMAS|SAMX", overlap=true),
    str_count_overlap.(map(x -> *(x...), diag2), "XMAS|SAMX", overlap=true)
))

println("Part 1: $p1")

mat = reduce(hcat, ts)

function is_x_mas(g)
    g[2,2] != "A" && return false
    sum([g[1,1], g[1,3], g[3,1], g[3,3]] .== "S") != 2 && return false
    sum([g[1,1], g[1,3], g[3,1], g[3,3]] .== "M") != 2 && return false
    (g[1,1] == g[3,3] || g[1,3] == g[3,1]) && return false
    return true
end

p2 = sum([is_x_mas(mat[((cx-1):(cx+1), (cy-1):(cy+1))...]) for
    (cx, cy) in Iterators.product(2:(nl-1),2:(nl-1))])

println("Part 2: $p2")
