include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("creategraph.jl")
include("kruskal.jl")

using Test

if false

#Exemple facilitant les tests unitaires

A=Node("a","A",nothing)
B=Node("b","B",nothing)
C=Node("c","C",nothing)
D=Node("d","D",nothing)
E=Node("e","E",nothing)
F=Node("f","F",nothing)
set_parent!(A,A)
set_parent!(B,A)
set_parent!(C,B)
set_parent!(D,B)
set_parent!(E,E)
set_parent!(F,E)

# Test de find_root
println(@test find_root(A)==A)
println(@test find_root(B)==A)
println(@test find_root(C)==A)
println(@test find_root(F)==E)

AB=Edge([A,B],1)
AD=Edge([A,D],1)
BC=Edge([B,C],1)
CD=Edge([C,D],1)
AC=Edge([A,C],10)
BD=Edge([B,D],10)

g=Graph("g",[A,B,C,D],[AC,AD,BC,CD,AB,BD])
show(g)

#On s'attend à ce que l'algorithme du Kruskal renvoie un graphe à 3 arêtes parmi AB, AD, BC et CD
min_g=kruskal(g)
println(@test length(min_g.edges)==3)
for e in min_g.edges
    println(@test in(e,(AB,AD,BC,CD)))
end
show(min_g)

#Exemple des notes de cours
A=Node("a","A",nothing)
B=Node("b","B",nothing)
C=Node("c","C",nothing)
D=Node("d","D",nothing)
E=Node("e","E",nothing)
F=Node("f","F",nothing)
G=Node("g","G",nothing)
H=Node("h","H",nothing)
I=Node("i","I",nothing)

AB=Edge([A,B],4)
AH=Edge([A,H],8)
BH=Edge([B,H],11)
BC=Edge([B,C],8)
HI=Edge([H,I],7)
HG=Edge([H,G],1)
IG=Edge([I,G],6)
IC=Edge([I,C],2)
CD=Edge([C,D],7)
CF=Edge([C,F],4)
GF=Edge([G,F],2)
DF=Edge([D,F],14)
DE=Edge([D,E],9)
EF=Edge([E,F],10)

g2=Graph("g2",[A,B,C,D,E,F,G,H,I],[AB,AH,BH,BC,HI,HG,IG,IC,CD,CF,GF,DF,DE,EF])
show(g2)
println("\n Recherche d'arbre couvrant minimal")
show(kruskal(g2))

end

fic1 = "../../instances/stsp/bays29.tsp" 
fic2 = "../../instances/stsp/bayg29.tsp"

graph_braz = create_graph("g1", fic1)
graph_bayg = create_graph("g2", fic2)

println("\n Bayg29")
show(kruskal(graph_bayg))
println("\n Brazil58")
show(kruskal(graph_braz))