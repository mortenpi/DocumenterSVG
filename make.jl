push!(LOAD_PATH, joinpath(@__DIR__, "dev"))
using Documenter, DocumenterSVG
makedocs(sitename="Documenter Extension")