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


function poids_tournee(graph::Graph{T}) where T
    poids_total = 0
    for edge in graph.edges
        poids_total = poids_total + edge.weight
    end
    poids_total
end

function test()
    # Test 1  : Sur un exemple simple ---------------------------------------------------

    A=Node("a","A",nothing,Inf,0,0)
    B=Node("b","B",nothing,Inf,0,0)
    C=Node("c","C",nothing,Inf,0,0)
    D=Node("d","D",nothing,Inf,0,0)
    E=Node("e","E",nothing,Inf,0,0)
    F=Node("f","F",nothing,Inf,0,0)

    AB=Edge([A,B],2)
    AC=Edge([A,C],8)
    AF=Edge([A,F],3)
    AD=Edge([A,D],4)
    CD=Edge([C,D],2)
    BC=Edge([B,C],3)
    BD=Edge([B,D],5)
    BE=Edge([B,E],4)
    CF=Edge([C,F],7)
    DE=Edge([D,E],4)
    EF=Edge([E,F],2)

    graph_1=Graph("G",[A,B,C,D,E,F],[AB,AC,AF,AD,CD,CF,BC,BD,BE,EF,DE])

    tournee1_hk = hk(graph_1)
    tournee1_rsl_prim = rsl_prim(graph_1)
    tournee1_rsl_kruskal = rsl_kruskal(graph_1)

    println(@test poids_tournee(tournee1_hk)<20)
    println(@test poids_tournee(tournee1_rsl_prim)<20)
    println(@test poids_tournee(tournee1_rsl_kruskal)<20)

    # Test 2  : Sur des instances stsp ------------------------------------------------
    repertoire = "C:/Users/Hugo/Desktop/Poly Montréal/MTH6412 - Implémentation d'Algorithme de Recherche Opérationnelle/Proj Code/mth6412b-starter-code/instances/stsp"
    
        # Sur bays29 -> Poids min = 2020

    fic1 = string(repertoire,"/bays29.tsp")
    graph_2 = create_graph("graph2", fic1)

    tournee2_hk = hk(graph_2)
    tournee2_rsl_prim = rsl_prim(graph_2)
    tournee2_rsl_kruskal = rsl_kruskal(graph_2)

    println(@test poids_tournee(tournee2_hk)<4040)
    println(@test poids_tournee(tournee2_rsl_prim)<4040)
    println(@test poids_tournee(tournee2_rsl_kruskal)<4040)


         # Sur bays29 -> Poids min = 2020

    fic1 = string(repertoire,"/bays29.tsp")
    graph_2 = create_graph("graph2", fic1)

    tournee2_hk = hk(graph_2)
    tournee2_rsl_prim = rsl_prim(graph_2)
    tournee2_rsl_kruskal = rsl_kruskal(graph_2)

    println(@test poids_tournee(tournee2_hk)<4040)
    println(@test poids_tournee(tournee2_rsl_prim)<4040)
    println(@test poids_tournee(tournee2_rsl_kruskal)<4040)

        # Sur dantzig42 -> Poids min = 699

    fic2 = string(repertoire,"/dantzig42.tsp")
    graph_3 = create_graph("graph3", fic2)
 
    tournee3_hk = hk(graph_3)
    tournee3_rsl_prim = rsl_prim(graph_3)
    tournee3_rsl_kruskal = rsl_kruskal(graph_3)
 
    println(@test poids_tournee(tournee3_hk)<1398)
    println(@test poids_tournee(tournee3_rsl_prim)<1398)
    println(@test poids_tournee(tournee3_rsl_kruskal)<1398)

        # Sur swiss42 -> Poids min = 1273

    fic3 = string(repertoire,"/swiss42.tsp")
    graph_4 = create_graph("graph4", fic3)
 
    tournee4_hk = hk(graph_4)
    tournee4_rsl_prim = rsl_prim(graph_4)
    tournee4_rsl_kruskal = rsl_kruskal(graph_4)
 
    println(@test poids_tournee(tournee4_hk)<2546)
    println(@test poids_tournee(tournee4_rsl_prim)<2546)
    println(@test poids_tournee(tournee4_rsl_kruskal)<2546)


        # Sur brazil58 -> Poids min = 25395

    fic4 = string(repertoire,"/brazil58.tsp")
    graph_5 = create_graph("graph5", fic4)
 
    tournee5_hk = hk(graph_5)
    tournee5_rsl_prim = rsl_prim(graph_5)
    tournee5_rsl_kruskal = rsl_kruskal(graph_5)
 
    println(@test poids_tournee(tournee5_hk)<50790)
    println(@test poids_tournee(tournee5_rsl_prim)<50790)
    println(@test poids_tournee(tournee5_rsl_kruskal)<50790)
end

test()