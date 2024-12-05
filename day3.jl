using TidierStrings
using TidierData

function str_extract_all_cap(string::AbstractString, pattern::Union{String, Regex}; captures::Bool=false)
    regex_pattern = isa(pattern, String) ? Regex(pattern) : pattern
    to_missing(l) = [ifelse(isnothing(c), missing, c) for c in l]
    matches = captures ?
        [to_missing(m.captures) for m in eachmatch(regex_pattern, string)] :
        [String(m.match) for m in eachmatch(regex_pattern, string)]
    return isempty(matches) ? missing : matches
end

@chain *(readlines("data/3.txt")...) begin
    str_extract_all_cap(r"mul\((?<n1>\d+),(?<n2>\d+)\)", captures = true)
    map(x -> prod(parse.(Int, x)), _)
    sum
end

@chain *(readlines("data/3.txt")...) begin
    str_extract_all_cap(r"mul\((\d+),(\d+)\)|(do(?:n't)?\(\))", captures = true)
    DataFrame(mapreduce(permutedims, vcat, _), :auto)
    @fill_missing(x3, "down")
    @mutate(x3 = replace_missing(x3, "do()"))
    @filter(x3 != "don't()")
    @mutate(prod = as_integer(x1) * as_integer(x2))
    @filter(!ismissing(prod))
    @pull(prod)
    sum
end
