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

N,E=read_stsp("bayg29.tsp")
println(N,E)

function create_graph(filename::String)
    """crée un graphe à partir d'une instance de TSP symétrique dont les poids des arêtes sont donnés au format EXPLICIT.
    Les noms des noeuds seront des entiers de 1 à n, n étant la dimension du graphes.
    Les données qu'ils contiendront seront un tableau de taille 2 de type Array{Float} comportant leurs coordonnées."""

    #On commence par l'identification du header
    H=read_header(filename)

end