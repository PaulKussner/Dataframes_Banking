# Some information on this program can be found in the README.md

using DataFrames
using CSV

"""
    monthly_due(id::Integer)

Calculates "Credit amount"/"Duration" of the citizens with matching id.

Return monthly payment.

# Arguments
    - `id::Integer` if given return monthly payment of single customer. Otherwise calculate for all customers.
"""
function monthly_due(id::Integer, citizens)
    credit_details = view(citizens, citizens."id" .== id, ["Credit amount","Duration"]);
    credit_amount = credit_details[!,1]
    duration = credit_details[!,2]
    return credit_amount/duration
end

monthly_due() = citizens."Credit amount" ./ citizens."Duration"

"""
    transfer_to_archive()

Delete all rows from global "citizens" where "Credit amount" has been paid off and add them to the archive.
"""
function transfer_to_archive()
    payed_off = filter(row -> row."Duration" <= 0, citizens)
    global citizens = filter!(row -> row."Duration" > 0, citizens)
    global archive = vcat(archive, payed_off)
    #return citizens, archive
end

""" 
    update_archive()

Sets "Credit amount" in the archive to 0 since no further payment is necessary. 
Delete all rows that are in the archive for more than a year. 
"""
function update_archive()
    global archive = filter!(row -> row."Duration" > -13, archive) # delete all rows where the credit has been paid back 1 year ago
    global archive."Credit amount" .= 0
end

"""
    year_passed(printout = true)

Update age, credit amount and duration for a whole year passed. Transfer paid credits into the archive. 
Delete obsolete entries from the archive. Print the new Dataframes into the REPL.
"""
function year_passed(printout = true)
    monthly = monthly_due()

    citizens[!,"Age"] = citizens[!,"Age"] .+ 1 # make them all one year older
    citizens[!,"Duration"] .-= 12
    citizens[!,"Credit amount"] .-= 12 .* monthly

    archive[!,"Age"] = archive[!,"Age"] .+ 1 # make them all one year older
    archive[!,"Duration"] .-= 12

    transfer_to_archive()

    update_archive()

    if printout
        println("Archive:")
        println(archive)
        
        println("Citizens:")
        println(citizens)
    end

    #return citizens, archive
end

"""
    new_customer(age::Int64, credit_amount::Int64, duration::Int64; sex = "NA", job = "NA", housing="NA", savings = "NA", checking = "NA", purpose = "NA")

Add a new customer into citizens. 

Age, Credit amount and Duration must be given while the other categories are optional. Uses a global running index to index the new customer.
"""
function new_customer(age::Int64, credit_amount::Int64, duration::Int64; sex = "NA", job = "NA", housing="NA", savings = "NA", checking = "NA", purpose = "NA")
    global ID += 1
    row = [ID, age, sex, job, housing, savings, checking, credit_amount, duration, purpose]
    dummy = DataFrame([name => x for (x,name) in zip(row, names(citizens))])
    global citizens = vcat(citizens, dummy)
end

"""
    initiate()

Load the example data and create an archive.
"""
function initiate()
    path = joinpath(pkgdir(DataFrames), "docs", "src", "assets", "german.csv");
    citizens = CSV.read(path, DataFrame)[1:50,:]

    archive = DataFrame([name => type[] for (type,name) in zip(eltype.(eachcol((citizens))) , names(citizens))])

    return citizens, archive
end

# Initiate global variables
global citizens, archive = initiate();
global ID = 50;