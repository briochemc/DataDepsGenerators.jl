module DataDepsGenerators
using Gumbo, Cascadia, AbstractTrees

export generate, UCI


abstract type DataRepo end

struct Metadata
    fullname::String
    website::String
    to_cite::Vector{String}
    description::String
    dataurls::Vector{String}
end


function message(meta)
    cite_block = join("- ".*meta.to_cite, "\n")

    """
    Dataset: $(meta.fullname)
    Website: $(meta.website)
    $(meta.description)

    If you make use of this data it is requested that you cite:
    $(cite_block)
    """
end



include("utils.jl")
include("generic_extractors.jl")
include("UCI.jl")

function data_shortnamename(repo::DataRepo, dataname)
    string(typeof(repo).name.name) * " " * dataname
end

function generate(repo::DataRepo, dataname)
    shortname = data_shortnamename(repo, dataname)
    meta = find_metadata(repo, dataname)
    """
    RegisterDataDep(
        \"$shortname\",
        \"\"\"
    $(indent(message(meta)))\"\"\",
        $(meta.dataurls)
    )
    """
end


end # module
