
data_lines = [
"Country                       Pollution             Healthcare            Water       Life",
"Argentina                     13.67861608           4.78591616            98.9        76.251999",
"Armenia                       25.08644703           4.48014942            100         74.254997",
"Australia                     5.932051308           9.42230024            100         82.558998",
"Austria                       16.45924852           11.20547328           100         81.25",
"Azerbaijan                    28.0060253            6.0368632             86.2        71.800003",
"Bahamas                       13.72387382           7.74236489            98.4        75.378998",
"Bahrain                       60.33412401           4.98079638            100         76.622002",
"Bangladesh                    87.03455404           2.81899856            86.2        71.803001",
"Barbados                      15.20732479           7.469303              99.7        75.602997",
"Belarus                       20.03426999           5.68772158            99.7        72.504997",
"Belgium                       15.78042979           10.5947509            100         80.792",
"Belize                        25.45071189           5.78895004            99.5        70.027",
"Benin                         38.37472292           4.59429651            77.8        60.373001",
"Bhutan                        54.13286886           3.57301481            100         69.43",
"Bolivia                       28.35787923           6.33482729            90          68.357002",
"Bosnia and Herzegovina        44.09811958           9.57201597            99.9        76.560997",
"Botswana                      18.00413861           5.41200262            96.2        64.779999",
"Brazil                        11.31754584           8.32283359            98.1        75.042",
"Bulgaria                      27.53486186           8.44291326            99.4        74.473",
"Burkina Faso                  44.14409051           4.96026323            82.1        59.457001",
"Burundi                       47.29057045           7.53556539            75.8        56.688",
]


function field_start_positions(header::String)
    positions = [m.offset for m in eachmatch(r"\S+", header)]
    return positions
end

function parse_line(line, hsymbols, positions)
    pFloat(num) = parse(Float64, num)

    start = copy(positions)
    stopp = circshift(start, -1) .- 1
    stopp[end] = lastindex(line)

    fields = String[]
    for (strt,stpp) in zip(start,stopp)
        push!(fields, strip(line[strt:stpp]))
    end
    vals = (fields[1],
            pFloat(fields[2]), pFloat(fields[3]), pFloat(fields[4]), pFloat(fields[5]))
    return (; zip(hsymbols, vals)...)
end

header = data_lines[1]
hsymbols = Tuple(Symbol(hname) for hname in split(header))
field_positions = field_start_positions(header)
table = [parse_line(line, hsymbols, field_positions) for line in data_lines[2:end]]

# hsymbols = Tuple(Symbol(hname) for hname in split(header))
# table = [NamedTuple{hsymbols}(row) for row in parsed_data]

for r in table
   println(r)
end

#ftypes = (String, Float64, Float64, Float64, Float64)
#[parse(ftypes[i], parsed_data[2][i]) for i in 2:5]
