include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

if false
    A=Node("A","a")
    B=Node("B","b")
    show(A)
    show(B)

    AB=Edge([A,B],12)
    show(AB)

    G=Graph("G",Node{String}[],Edge{String}[])
    show(G)
    add_node!(G,A)
    add_node!(G,B)
    add_edge!(G,AB)
    show(G) 
end

#T=read_header("bayg29.tsp")
#println(T)
#N=read_nodes(T,"bays29.tsp")
#E=read_edges(T,"bays29.tsp")

"""Renvoie le noeud du graphe dont le nom correspond à celui donné en paramètre"""
function find_node_of_name(graph::Graph,name::String)
    n = 1
    nb = length(graph.nodes)
    while n <= nb && graph.nodes[n].name != name
        n += 1
    end
    if n > nb
        error("Node not in graph")
    else
        return graph.nodes[n]
    end
end   

"""Crée un graphe à partir d'un fichier au format TSPLib avec poids des arêtes EXPLICIT"""
function create_graph(name::String,filename::String)    
    graph = Graph(name,Node{Vector{Float64}}[],Edge{Vector{Float64}}[])
    N,E = read_stsp(filename)
    
    if length(N)>0
        for node in keys(N)
            name = string(node)
            add_node!(graph,Node(name,N[node]))
        end
    else
        dim = parse(Int, read_header(filename)["DIMENSION"])
        T = valtype(N)
        for k in 1:dim
            add_node!(graph,Node{T}("$k", T()))
        end
    end
    for k in 1:length(E)
        name1 = string(k)
        node1 = find_node_of_name(graph,name1)
        for edge in E[k]
            name2 = string(edge[1])
            node2 = find_node_of_name(graph,name2)
            weight = edge[2]
            add_edge!(graph, Edge([node1,node2],weight))
        end
    end
    return graph
end

g=create_graph("g","swiss42.tsp")