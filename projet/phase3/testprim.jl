include("node.jl")
include("edge.jl")
include("graph.jl")
include("queue.jl")
include("heuristics.jl")
include("prim.jl")
include("creategraph.jl")
include("read_stsp.jl")

function test_prim(filename::String)
    fic1 = "../../instances/stsp/"*filename*".tsp"

    G1 = create_graph("g1", fic1)

    test=prim(G1,G1.nodes[1])
    show(test)
end

test_prim("swiss42")