using FStrings
using Statistics: mean

predict(X, w) = X * w

loss(X,Y, w) = mean((predict(X, w) - Y) .^ 2)

function gradient(X, Y, w)
    dY = (predict(X, w) - Y)./size(X, 1)
    w_grad = 2 * X' * dY
    return w_grad
end

function train(X, Y; iterations, lr)
    w = zeros(size(X, 2))
    for ii = 0:iterations-1
        # println(f"Iteration {ii:4d} => Loss: {loss(X, Y, w):.10f}")
        dw = gradient(X, Y, w)
        w -= lr*dw
    end
    return w
end

function column_symbols(header::String)
    names = split(header)
    return ntuple(i -> Symbol(names[i]), length(names))
end

function field_start_positions(header::String)
    matches = collect(eachmatch(r"\S+", header))
    return ntuple(i -> matches[i].offset, length(matches))
end

function field_end_positions(pstart::NTuple{N,Int}) where {N}
    pstop = pstart[2:end] .- 1
    return pstop
end

function try_parse_number(s::AbstractString)
    for T in (Int, Float64)
        parsed = tryparse(T, s)
        isnothing(parsed) || return parsed
    end
    return s
end

function compute_column_ranges(pstart::NTuple{N,Int}, line) where {N}
    pstop = ((pstart[2:end] .- 1)..., lastindex(line))
    zip(pstart, pstop)
end

function compute_column_ranges(pstart::NTuple{N,Int}, pstop::NTuple{M,Int}, line) where {N,M}
    pstop = (pstop..., lastindex(line))
    zip(pstart, pstop)
end

function parse_line(line::AbstractString,
    colsym::NTuple{N,Symbol},
    pstart::NTuple{N,Int},
    pstop::NTuple{M,Int}) where {N,M}
    fields = [strip(line[cstart:cstop])
             for (cstart, cstop) in compute_column_ranges(pstart, pstop, line)]
    NamedTuple{colsym}(try_parse_number.(fields))
end

function parse_line(line::AbstractString, colsym::NTuple{N,Symbol}) where {N}
    fields = split(line, r" {2,}", keepempty=false)
    NamedTuple{colsym}(try_parse_number.(fields))
end

open("../data/life-expectancy/life-expectancy.txt") do file
    header = readline(file)
    colsym = column_symbols(header)
    startpos = field_start_positions(header)
    endpos = field_end_positions(startpos)

    T = NamedTuple{(:country, :data), Tuple{String, Tuple{Vararg{Float64}}}}
    names = colsym
    types = (String, Float64, Float64, Float64, Float64)
    T = NamedTuple{names, Tuple{types...}}
    table = Vector{T}()

    for line in eachline(file)
        push!(table, parse_line(line, colsym))
    end
end

data = reduce(vcat, [collect(values(nt)[2:end])' for nt in table])
countries = [nt[1] for nt in table]

X = hcat(ones(size(data,1)), data[:, 1:3])
Y = data[:, 4]
w = train(X, Y, iterations=10, lr=1E-4)

println("Weights: ", w)
println("A few predictions:")
pdct = predict(X, w)
for i = 1:length(countries)
     println(f"{countries[i]} label: {Y[i]:.2f} {pdct[i]:.2f} {Y[i]-pdct[i]:.2f}")
 end
 println("DONE")

