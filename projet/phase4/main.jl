#using Plots
using Test

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

if false
    A=Node("a","A",nothing,Inf,0,0)
    B=Node("b","B",nothing,Inf,0,0)
    C=Node("c","C",nothing,Inf,0,0)
    D=Node("d","D",nothing,Inf,0,0)
    E=Node("e","E",nothing,Inf,0,0)
    F=Node("f","F",nothing,Inf,0,0)
    G=Node("g","G",nothing,Inf,0,0)
    H=Node("h","H",nothing,Inf,0,0)
    I=Node("i","I",nothing,Inf,0,0)

    AB=Edge([A,B],4)
    AH=Edge([A,H],7)
    BC=Edge([B,C],8)
    BH=Edge([B,H],11)
    CD=Edge([C,D],7)
    CF=Edge([C,F],4)
    CI=Edge([C,I],2)
    DE=Edge([D,E],9)
    DF=Edge([D,F],14)
    EF=Edge([E,F],10)
    FG=Edge([F,G],2)
    GH=Edge([G,H],1)
    GI=Edge([G,I],6)
    HI=Edge([H,I],7)
    AI=Edge([A,I],20)
    EI=Edge([E,I],20)

    g=Graph("G",[A,B,C,D,E,F,G,H,I],[AB,AH,BC,BH,CD,CF,CI,DE,DF,EF,FG,GH,GI,HI,AI,EI])
end

fic1 = "../../instances/stsp/dantzig42.tsp"
G1 = create_graph("g1", fic1)
#plot_graph(G1,"bayg29")
G2 = hk(G1)
show(G2)
#plot_graph(G2,"bayg29_min_tsp")