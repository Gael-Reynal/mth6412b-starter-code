include("graph.jl")
include("read_stsp.jl")

A=Node("A","a")
B=Node("B","b")
C=Node("C","c")
AB=Edge((A,B),1)
AC=Edge((A,C),2)
BC=Edge((B,C),3)
#show(A)
#show(B)
#show(AB)

#println("\nPartie graphe\n")
G=Graph("G",[A,B],[AB])
#show(G)
add_node!(G,C)
add_edge!(G,AC)
add_edge!(G,BC)
#show(G)


function create_graph(filename::String)
    """crée un graphe à partir d'une instance de TSP symétrique dont les poids des arêtes sont donnés au format EXPLICIT.
    Les noms des noeuds seront des entiers de 1 à n, n étant la dimension du graphes.
    Les données qu'ils contiendront seront un tableau de taille 2 de type Array{Float} comportant leurs coordonnées."""

    #On commence par récupérer les données du fichier
    N,E=read_stsp(filename)

    #On crée la liste des noeuds
    nodes=Node{Array{Float64,1}}[]
    for node in keys(N)
        n=Node(string(node),N[node])
        push!(nodes,n)
    end

    #On crée la liste des arêtes
    edges=Edge{}
    return nodes
end

graph_nodes=create_graph("bays29.tsp")
for n in graph_nodes
    show(n)
end