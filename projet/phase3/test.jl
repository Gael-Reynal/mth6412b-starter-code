include("node.jl")
include("edge.jl")
include("graph.jl")
include("queue.jl")
include("heuristics.jl")
include("prim.jl")
include("creategraph.jl")
include("read_stsp.jl")

using Test

# Heuristiques d'accélération ----------------------------------

println("Compression des chemins")

A=Node("a","A",nothing,0)
B=Node("b","B",A,0)
C=Node("c","C",B,0)
D=Node("d","D",B,0)

println(@test find_root_compressed(A)==A)
println(@test find_root_compressed(B)==A)
println(@test find_root_compressed(C)==A)
println(@test C.par==A)
println(@test D.par==B)

println("Union par le rang")
println(@test rank_merge(A,D)=="Même composante")

E=Node("d","D",nothing,1)
F=Node("d","D",nothing,1)
rank_merge(A,E)
println(@test A.value==0)
println(@test E.value==1)
rank_merge(E,F)
println(@test E.value==2)

# Algorithme de Prim : cas limites
println("Algorithme de Prim")
G0=Graph("",[A],Edge{String}[])
println(@test isequal(prim(G0,A),G0))

# Test 1 -------------------------------------------------------

println("Exemple des notes de cours")
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

G1 = Graph("G1",[A,B,C,D,E,F,G,H,I],[AB,AH,BC,BH,CD,CF,CI,DE,DF,EF,FG,GH,GI,HI])
G1_min_A = Graph("G1_min_A",[A,B,C,D,E,F,G,H,I],[AB,AH,GH,FG,CF,CI,CD,DE])
G1_min_F = Graph("G1_min_F",[A,B,C,D,E,F,G,H,I],[AB,AH,CD,CF,CI,DE,FG,GH])


println(@test isequal(prim(G1,A), G1_min_A))
println(@test isequal(prim(G1,F), G1_min_F))


# Test 2 -------------------------------------------------------

println("Exemple plus simple")
A=Node("a","A",nothing,Inf)
B=Node("b","B",nothing,Inf)
C=Node("c","C",nothing,Inf)
D=Node("d","D",nothing,Inf)
E=Node("e","E",nothing,Inf)
F=Node("f","F",nothing,Inf)

AB=Edge([A,B],1)
AC=Edge([A,C],2)
AE=Edge([A,E],10)
BE=Edge([B,E],3)
BD=Edge([B,D],4)
CE=Edge([C,E],8)
DF=Edge([D,F],5)
EF=Edge([E,F],6)


G2 = Graph("G2",[A,B,C,D,E,F],[AB,AC,AE,BE,BD,CE,DF,EF])
G2_min_A = Graph("G2_min_A",[A,B,C,D,E,F],[AB,AC,BE,BD,DF])


println(@test isequal(prim(G2,A), G2_min_A))


# Test 3 -------------------------------------------------------

println("Exemple avec plusieurs solutions")
A=Node("a","A",nothing,Inf)
B=Node("b","B",nothing,Inf)
C=Node("c","C",nothing,Inf)
D=Node("d","D",nothing,Inf)
E=Node("e","E",nothing,Inf)
F=Node("f","F",nothing,Inf)

AB=Edge([A,B],3)
AC=Edge([A,C],7)
AE=Edge([A,E],3)
BE=Edge([B,E],1)
BD=Edge([B,D],2)
CF=Edge([C,F],5)
DF=Edge([D,F],6)
EF=Edge([E,F],8)


G3 = Graph("G3",[A,B,C,D,E,F],[AB,AC,AE,BE,BD,CF,DF,EF])

# Prim peut donner deux resultats différents en partant de A ou E
G3_min_A1 = Graph("G3_min_A1",[A,B,C,D,E,F],[AB,BE,BD,CF,DF])
G3_min_A2 = Graph("G3_min_A2",[A,B,C,D,E,F],[AE,BE,BD,CF,DF])
G3_min_E1 = Graph("G3_min_E1",[A,B,C,D,E,F],[AB,BE,BD,CF,DF])
G3_min_E2 = Graph("G3_min_E2",[A,B,C,D,E,F],[AE,BE,BD,CF,DF])

println(@test isequal(prim(G3,A), G3_min_A1)||isequal(prim(G3,A), G3_min_A2))
println(@test isequal(prim(G3,E), G3_min_E1)||isequal(prim(G3,E), G3_min_E2))


# Test 4 -------------------------------------------------------

A=Node("a","A",nothing,Inf)
B=Node("b","B",nothing,Inf)
C=Node("c","C",nothing,Inf)
D=Node("d","D",nothing,Inf)
E=Node("e","E",nothing,Inf)

AB=Edge([A,B],3)
AC=Edge([A,C],4)
AD=Edge([A,D],6)
AE=Edge([A,E],3)
BC=Edge([B,C],7)
BD=Edge([B,D],7)
BE=Edge([B,E],2)
CD=Edge([C,D],5)
CE=Edge([C,E],6)
DE=Edge([D,E],1)



G4 = Graph("G4",[A,B,C,D,E],[AB,AC,AD,AE,BC,BD,BE,CD,CE,DE])

# Prim peut donner deux resultats différents en partant de A
G4_min_A1 = Graph("G4_min_A1",[A,B,C,D,E],[AB,BE,DE,AC])
G4_min_A2 = Graph("G4_min_A2",[A,B,C,D,E],[AC,AE,DE,BE])


println(@test isequal(prim(G4,A), G4_min_A1)||isequal(prim(G4,A), G4_min_A2))