include("node.jl")
include("edge.jl")
include("graph.jl")
include("queue.jl")
include("heuristics.jl")
include("prim.jl")
include("creategraph.jl")
include("read_stsp.jl")

A=Node("a","A",nothing,Inf)
B=Node("b","B",nothing,Inf)
C=Node("c","C",nothing,Inf)
D=Node("d","D",nothing,Inf)
E=Node("e","E",nothing,Inf)
F=Node("f","F",nothing,Inf)
G=Node("g","G",nothing,Inf)
H=Node("h","H",nothing,Inf)
I=Node("i","I",nothing,Inf)

AB=Edge([A,B],4)
AH=Edge([A,H],8)
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

G=Graph("G",[A,B,C,D,E,F,G,H,I],[AB,AH,BC,BH,CD,CF,CI,DE,DF,EF,FG,GH,GI,HI])

fic1 = "../../instances/stsp/bays29.tsp" 
fic2 = "../../instances/stsp/bayg29.tsp"

G1 = create_graph("g1", fic1)
G2 = create_graph("g2", fic2)

test=prim(G1,G1.nodes[1])
show(test)