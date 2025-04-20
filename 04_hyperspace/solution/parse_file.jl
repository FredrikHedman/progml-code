using StructArrays

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
    return String(s)
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

function read_file(fname::AbstractString)
    open(fname) do file
        header = readline(file)
        colnames = column_symbols(header)

        types = (String, Float64, Float64, Float64, Float64)
        RowType = NamedTuple{colnames, Tuple{types...}}
        rows = Vector{RowType}()

        for line in eachline(file)
            parsed_row = parse_line(line, colnames)
            push!(rows, parsed_row)
        end
        return StructArray(rows)
    end
end
