include("node.jl")
include("edge.jl")
include("graph.jl")
include("queue.jl")
include("heuristics.jl")
include("prim.jl")

"""Renvoie le parcours en préordre d'un arbre en considérant le noeud s comme source"""
function preorder(graph::Graph{T}, s::Node{T}, res::Vector{Node{T}}=Node{T}[]) where T
    push!(res,s)
    for n in graph.nodes
        if !(n in res)
            for edge in graph.edges
                if edge.limits==[n,s] || edge.limits==[s,n]
                    preorder(graph,n,res)
                end
            end
        end
    end
    return res
end

function rsl_prim(graph::Graph{T}) where T
    g_prim = prim(graph,graph.nodes[1])
    tournee = preorder(g_prim, graph.nodes[1])
    push!(tournee,graph.nodes[1])
    g_rsl = Graph(graph.name*"_rsl",graph.nodes,Edge{T}[])
    
    for k in 1:length(tournee)-1
        n1=tournee[k]
        n2=tournee[k+1]
        e=1
        arete=false
        while !arete && e<=length(graph.edges)
            if graph.edges[e].limits==[n1,n2] || graph.edges[e].limits==[n2,n1]
                add_edge!(g_rsl,graph.edges[e])
                arete=true
            end
            e+=1
            if e>length(graph.edges)
                println("arete pas dans le graphe",n1.data,n2.data)
            end
        end
    end
    return g_rsl
end

function rsl_kruskal(graph::Graph{T}) where T
    g_kruskal = kruskal(graph)
    tournee = preorder(g_kruskal, graph.nodes[1])
    push!(tournee,graph.nodes[1])
    g_rsl = Graph(graph.name*"_rsl",graph.nodes,Edge{T}[])
    
    for k in 1:length(tournee)-1
        n1=tournee[k]
        n2=tournee[k+1]
        e=1
        arete=false
        while !arete && e<=length(graph.edges)
            if graph.edges[e].limits==[n1,n2] || graph.edges[e].limits==[n2,n1]
                add_edge!(g_rsl,graph.edges[e])
                arete=true
            end
            e+=1
            if e>length(graph.edges)
                println("arete pas dans le graphe",n1.data,n2.data)
            end
        end
    end
    return g_rsl
end