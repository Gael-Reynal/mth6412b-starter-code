function poids_tournee(graph::Graph{T}) where T
    poids_total = 0
    for edge in graph.edges
        poids_total = poids_total + edge.weight
    end
    poids_total
end

function test()

    A=Node("a","A",nothing,Inf,0,0)
    B=Node("b","B",nothing,Inf,0,0)
    C=Node("c","C",nothing,Inf,0,0)
    D=Node("d","D",nothing,Inf,0,0)

    AB=Edge([A,B],2)
    AC=Edge([A,C],8)
    AD=Edge([A,D],4)
    BD=Edge([B,D],4)
    BC=Edge([B,C],3)
    DC=Edge([D,C],4)

    g=Graph("",[A,B,C,D],[AB,AC,BC])
    g1=Graph("g",[A,B,C,D],[AB,AC,BC,BC,BD,DC])

    # Test de la fonction find_deg
    println("Test de find_deg")
    println(@test find_deg(g,A)==2)
    println(@test find_deg(g,D)==0)
    
    # Test 1  : Sur un exemple simple ---------------------------------------------------

    A=Node("a","A",nothing,Inf,0,0)
    B=Node("b","B",nothing,Inf,0,0)
    C=Node("c","C",nothing,Inf,0,0)
    D=Node("d","D",nothing,Inf,0,0)
    E=Node("e","E",nothing,Inf,0,0)
    F=Node("f","F",nothing,Inf,0,0)
    G=Node("g","G",nothing,Inf,0,0)
    H=Node("h","H",nothing,Inf,0,0)

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

    tournee1_hk = hk_prim(graph_1)
    tournee1_rsl_prim = rsl_prim(graph_1)
    tournee1_rsl_kruskal = rsl_kruskal(graph_1)

    println(@test total_cost(tournee1_hk)<20)
    println(@test total_cost(tournee1_rsl_prim)<20)
    println(@test total_cost(tournee1_rsl_kruskal)<20)

    # Test 2  : Sur des instances stsp ------------------------------------------------
    repertoire = "../../instances/stsp"

        # Sur bays29 -> Poids min = 2020

    fic1 = string(repertoire,"/bays29.tsp")
    graph_2 = create_graph("graph2", fic1)

    tournee2_hk = hk_prim(graph_2)
    tournee2_rsl_prim = rsl_prim(graph_2)
    tournee2_rsl_kruskal = rsl_kruskal(graph_2)

    println(@test total_cost(tournee2_hk)<4040)
    println(@test total_cost(tournee2_rsl_prim)<4040)
    println(@test total_cost(tournee2_rsl_kruskal)<4040)


         # Sur bays29 -> Poids min = 2020

    fic1 = string(repertoire,"/bays29.tsp")
    graph_2 = create_graph("graph2", fic1)

    tournee2_hk = hk_prim(graph_2)
    tournee2_rsl_prim = rsl_prim(graph_2)
    tournee2_rsl_kruskal = rsl_kruskal(graph_2)

    println(@test total_cost(tournee2_hk)<4040)
    println(@test total_cost(tournee2_rsl_prim)<4040)
    println(@test total_cost(tournee2_rsl_kruskal)<4040)
end