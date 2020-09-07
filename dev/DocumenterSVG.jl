module DocumenterSVG
using Documenter: Expanders
using Documenter.Utilities: Selectors
using Documenter.Writers: HTMLWriter
using Documenter.Utilities.DOM

struct SVGBlock
    height :: Int
    width :: Int
end

abstract type SVGBlocks <: Expanders.ExpanderPipeline end

Selectors.order(::Type{SVGBlocks}) = 12.0

Selectors.matcher(::Type{SVGBlocks}, node, page, doc) = Expanders.iscode(node, r"^@svg")

function Selectors.runner(::Type{SVGBlocks}, x, page, doc)
    d = Core.eval(Main, Meta.parse(x.code))
    isa(d, Dict) || error("!!!")
    page.mapping[x] = SVGBlock(d[:height], d[:width])
    return nothing
end

function HTMLWriter.domify(ctx, navnode, block::SVGBlock)
    @tags svg polygon
    scale = min(block.height/200, block.width/100)
    @info "Calling domify(::SVGBlock)" block scale
    # https://www.w3schools.com/graphics/tryit.asp?filename=trysvg_polygon4
    svg[:height => "$(block.height)", :width => "$(block.width)"](
        polygon[
            :transform => "scale($scale)",
            :points => "100,10 40,198 190,78 10,78 160,198",
            :style => "fill:lime;stroke:purple;stroke-width:5;fill-rule:evenodd;"
        ]()
    )
end

end