
function convert_to_namedtuple(vec)
    # Generate field names as :field1, :field2, ...
    names = Symbol.("field" * string(i) for i in 1:length(vec))

    # Convert each element: Int if possible, else Float64, else String
    values = map(x -> tryparse(Int, x) !== nothing ? parse(Int, x) :
                      (tryparse(Float64, x) !== nothing ? parse(Float64, x) : x), vec)


    # Create NamedTuple from names and values
    return NamedTuple{names}(Tuple(values))
end

# Example usage
#nt = convert_to_namedtuple(vec)


function convert_to_namedtuple2(vec::AbstractVector{<:AbstractString})
    function convert(s::AbstractString)
        parsed_int = tryparse(Int, s)
        if !isnothing(parsed_int)
            return parsed_int
        else
            parsed_float = tryparse(Float64, s)
            if !isnothing(parsed_float)
                return parsed_float
            end
        end
        return s
    end

    keys = Symbol.('a':'a' + length(vec) - 1)
    vals = (convert(s) for s in vec)
    return (; zip(keys, vals)...)
end

test1 = ["Argentina", "13", "4.78591616", "-98", "76.251999"]
# Output: (field1 = "Argentina", field2 = 13, field3 = 4.78591616, field4 = -98, field5 = 76.251999)
println((test1))

test2 = ["100", "200.5", "hello", "300", "400.0"]
# Output: (field1 = 100, field2 = 200.5, field3 = "hello", field4 = 300, field5 = 400.0)
println(convert_to_namedtuple2(test2))

test3 = ["1", "2", "3", "4", "5"]  # All integers
# Output: (field1 = 1, field2 = 2, ..., field5 = 5)
println(convert_to_namedtuple2(test3))

test4 = ["3.14", "text", "0.0", "-1.5", "42"]
# Output: (field1 = 3.14, field2 = "text", ..., field5 = 42)
println(convert_to_namedtuple2(test4))
