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
    graph = Graph{Vector{Float64}}(name)
    N,E = read_stsp(filename)
    
    #Création de la liste de noeuds
    if length(N)>0
        for node in keys(N)
            n = Node{Vector{Float64}}(N[node],string(node),nothing)
            set_parent!(n,n)
            add_node!(graph,n)
        end
    else
        dim = parse(Int, read_header(filename)["DIMENSION"])
        T = valtype(N)
        for k in 1:dim
            n = Node{T}(T(),"$k",nothing)
            set_parent!(n,n)
            add_node!(graph,n)
        end
    end

    #Création de la liste des arêtes
    for k in 1:length(E)
        name1 = string(k)
        node1 = find_node_of_name(graph,name1)
        for edge in E[k]
            name2 = string(edge[1])
            node2 = find_node_of_name(graph,name2)
            weight = edge[2]
            add_edge!(graph, Edge{Vector{Float64}}([node1,node2],weight))
        end
    end
    return graph
end