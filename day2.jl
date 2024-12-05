using TidierFiles
using TidierData

df = read_csv("data/2.txt", col_names = false)

to_int(x) = parse.(Int, x)
check_safe(steps) = all(steps .> 0 .&& steps .<  4) ||
                    all(steps .< 0 .&& steps .> -4)

p1 = @chain df begin
    @transmute(list = to_int(split(Column1)))
    @mutate(steps = diff(list))
    @mutate(safe = check_safe(steps))
    @pull(safe)
    sum
end

println("Part 1: $p1")

check_all(l) = check_safe.(diff.([l[1:end .!= i] for i in 1:length(l)]))

p2 = @chain df begin
    @transmute(list = to_int(split(Column1)))
    @mutate(safe = any(check_all(list)))
    @pull(safe)
    sum
end

println("Part 2: $p2")
