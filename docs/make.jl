using ResourceManagement
using Documenter

DocMeta.setdocmeta!(ResourceManagement, :DocTestSetup, :(using ResourceManagement); recursive=true)

makedocs(;
    modules=[ResourceManagement],
    authors="Gil Junqueira",
    repo="https://github.com/gjunqueira-sys/ResourceManagement.jl/blob/{commit}{path}#{line}",
    sitename="ResourceManagement.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://gjunqueira-sys.github.io/ResourceManagement.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/gjunqueira-sys/ResourceManagement.jl",
    devbranch="master",
)
