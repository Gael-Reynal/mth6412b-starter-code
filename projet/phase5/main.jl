using Random, FileIO, Images, ImageView, ImageMagick

include("node.jl")
include("edge.jl")
include("graph.jl")
include("queue.jl")
include("heuristics.jl")
include("prim.jl")
include("kruskal.jl")
include("creategraph.jl")
include("read_stsp.jl")
include("onetree.jl")
include("rsl.jl")
include("hk.jl")
include("graphplot.jl")
include("tools.jl")

titles=["abstract-light-painting","alaska-railroad","blue-hour-paris","lower-kananaskis-lake","marlet2-radio-board","nikos-cat","pizza-food-wallpaper","the-enchanted-garden","tokyo-skytree-aerial"]
for f in titles
    G=create_graph(f,"./instances/"*f*".tsp")

    G1=Graph{Array{Float64,1}}(G.name*"1")
    for n in 2:length(G.nodes)
        add_node!(G1,G.nodes[n])
    end
    for edge in G.edges
        if !(edge.limits[1]==G.nodes[1]||edge.limits[2]==G.nodes[1])
            add_edge!(G1,edge)
        end
    end

    G2=rsl_prim(G1)
    e=maximum(G2.edges)
    idx = findall(x -> x == e, G2.edges)[1]
    bef=G2.edges[1:idx-1]
    aft=G2.edges[idx+1:end]

    t=Int[]
    push!(t,1)

    if e.limits[1] in bef[end].limits
        x=parse(Int,e.limits[1].name)
        push!(t,x-1)
    else
        x=parse(Int,e.limits[2].name)
        push!(t,x-1)
    end

    n1=length(bef)
    n2=length(aft)
    for edge in 1:n1
        x=parse(Int,bef[n1-edge+1].limits[1].name)
        if x-1==t[end]
            push!(t,parse(Int,bef[n1-edge+1].limits[2].name)-1)
        else
            push!(t,x-1)
        end
    end

    for edge in 1:n2
        x=parse(Int,aft[edge].limits[1].name)
        if x-1==t[end]
            push!(t,parse(Int,aft[edge].limits[2].name)-1)
        else
            push!(t,x-1)
        end
    end

    write_tour(f*".tour",t,total_cost(G2))
    reconstruct_picture(f*".tour", "./shuffled/"*f*".png", f*".png")
end