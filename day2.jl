using TidierFiles
using TidierData

df = read_csv("data/2test.txt", col_names = false)

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

check_all(l) = any(check_safe.(diff.([l[1:end .!= i] for i in 1:length(l)])))

p2 = @chain df begin
    @transmute(list = to_int(split(Column1)))
    @mutate(safe = check_all(list))
    @pull(safe)
    sum
end

println("Part 2: $p2")

DataFrame(Column1 =[
"7 6 4 2 1",
"1 2 7 8 9",
"9 7 6 2 1",
"1 3 2 4 5",
"8 6 4 4 1",
"1 3 6 7 9"]
)
