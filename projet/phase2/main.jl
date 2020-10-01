include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("creategraph.jl")
include("kruskal.jl")

if false
    A=Node("A",nothing,"a")
    B=Node("B",nothing,"b")
    C=Node("C",nothing,"c")
    D=Node("D",nothing,"d")
    set_parent!(A,A)
    set_parent!(B,B)
    set_parent!(C,C)
    set_parent!(D,D)

    AB=Edge([A,B],1)
    AD=Edge([A,D],1)
    BC=Edge([B,C],1)
    CD=Edge([C,D],1)
    AC=Edge([A,C],10)
    BD=Edge([B,D],10)

    g=Graph("g",[A,B,C,D],[AC,AD,BC,CD,AB,BD])
    show(g)
    show(kruskal(g))
end

g=create_graph("g","../../instances/stsp/bayg29.tsp")
show(g)
println("\n Recherche d'arbre minimal :\n")
show(kruskal(g))