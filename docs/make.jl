using Working_With_Data
using Documenter

DocMeta.setdocmeta!(Working_With_Data, :DocTestSetup, :(using Working_With_Data); recursive=true)

makedocs(;
    modules=[Working_With_Data],
    authors="Paul Kussner paul.kuessner@student.uibk.ac.at",
    sitename="Working_With_Data.jl",
    format=Documenter.HTML(;
        canonical="https://PaulKussner.github.io/Working_With_Data.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/PaulKussner/Working_With_Data.jl",
    devbranch="master",
)
