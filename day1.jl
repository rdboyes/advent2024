using TidierFiles
using TidierData

df = read_csv("data/1.txt", col_names=false, delim="   ")

p1 = @chain DataFrame(c1=sort(df.Column1), c2=sort(df.Column2)) begin
    @mutate(diff = abs(c1 - c2))
    @pull(diff)
    sum
end

println("Part 1: $p1")

p2 = @chain df begin
    @aside c1 = @count(_, Column1)
    @count(Column2)
    @rename(n_1 = n)
    @left_join(c1, "Column2" = "Column1")
    @mutate(sim_score = Column2 * n * n_1)
    @filter(!ismissing(sim_score))
    @pull(sim_score)
    sum
end

print("Part 2: $p2")

import Base.adjoint

Base.adjoint(f::Function) = x -> f.(x)
p1 = sum ∘ abs' ∘ sum ∘ diff ∘ sort' ∘ eachcol ∘ readdlm
p1("data/1.txt")
# 2.742123e6
