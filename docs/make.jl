using BLPitot
using Documenter

DocMeta.setdocmeta!(BLPitot, :DocTestSetup, :(using BLPitot); recursive=true)

makedocs(;
    modules=[BLPitot],
    authors="= <pjabardo@ipt.br> and contributors",
    sitename="BLPitot.jl",
    format=Documenter.HTML(;
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
