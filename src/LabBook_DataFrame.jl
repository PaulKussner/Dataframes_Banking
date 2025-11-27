# LabBook.jl — simple lab-book DataFrame utilities
using DataFrames, CSV, Dates

# Create an empty lab book DataFrame 
function new_labbook()
    DataFrame(
        Date = Date[],                       
        EntryID = String[],     # unique identifier for the entry
        Title = String[],
        Researcher = String[],
        Description = String[],
        Observations = String[],
        Results = String[],
        Notes = String[],
        StartTime = Union{Missing,DateTime}[],
        EndTime = Union{Missing,DateTime}[],
        DurationMin = Union{Missing,Float64}[], # given in minutes
    )
end

# Add an entry (appends a row). Materials and attachments are vectors of strings.
function add_entry!(df::DataFrame;
        date::Date = today(),
        entryid::AbstractString = string(Dates.format(now(), "yyyymmddHHMMSS")),
        title::AbstractString = "",
        researcher::AbstractString = "",
        description::AbstractString = "",
        observations::AbstractString = "",
        results::AbstractString = "",
        notes::AbstractString = "",
        starttime::Union{Missing,DateTime} = missing,
        endtime::Union{Missing,DateTime} = missing
    )
    duration = missing #Calculate duration from start to end
    if starttime !== missing && endtime !== missing
        duration = Dates.value(endtime - starttime) # should be in minutes
    end

    #Append to labbook
    push!(df, (
        date,
        string(entryid),
        string(title),
        string(researcher),
        string(description),
        string(observations),
        string(results),
        string(notes),
        starttime,
        endtime,
        duration
    ))
    return df
end

# Save to CSV (materials/attachments flattened with separator). Good for human-readable exports.
function save_labbook_csv(df::DataFrame, path::AbstractString)
    CSV.write(path, df)
end

# Load CSV exported with save_labbook_csv. 
function load_labbook_csv(path::AbstractString)
    df = CSV.read(path, DataFrame; stringtype=String)
    return df
end

# Example usage
function example_Labbook()
    lb = new_labbook()
    add_entry!(lb;
        date = Date(2025, 11, 24),
        entryid = "EXP-001",
        title = "Example Entry",
        researcher = "Paul K.",
        description = "Testing the lab book functionality.",
        observations = "It worked maybe",
        results = "Unclear",
        notes = "AI helped me",
        starttime = DateTime(2025,11,24,9,0),
        endtime = DateTime(2025,11,24,11,15)
    )
    println(lb)
    return lb
end