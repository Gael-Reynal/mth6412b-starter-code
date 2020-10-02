include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("creategraph.jl")
include("kruskal.jl")

using Test

if false
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
end

g=create_graph("g","../../instances/stsp/bayg29.tsp")
show(g)
println("\n Recherche d'arbre minimal :\n")
show(kruskal(g))