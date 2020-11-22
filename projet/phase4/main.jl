using Plots
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
include("test.jl")

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

function total()
    fic1 = "bayg29"
    fic2 = "bays29"
    fic3 = "brazil58"
    fic4 = "dantzig42"
    fic5 = "fri26"
    fic6 = "gr17"
    fic7 = "gr21"
    fic8 = "gr24"
    fic9 = "gr48"
    fic10 = "hk48"
    fic11 = "swiss42"
    fic12 = "gr120"
    fic13 = "brg180"
    fic14 = "pa561"

    fic=[fic1,fic2,fic3,fic4,fic5,fic6,fic7,fic8,fic9,fic10,fic11,fic12,fic13,fic14]

    rk=Float64[]
    rp=Float64[]
    hkk=Float64[]
    hkp=Float64[]

    for f in fic
        G=create_graph(f,"../../instances/stsp/"*f*".tsp")
        if G.nodes[1].data!=Float64[]
            plot_graph(G,f)
        end

        G1=rsl_kruskal(G)
        push!(rk,total_cost(G1))
        G2=rsl_prim(G)
        push!(rp,total_cost(G2))
        G3=hk_kruskal(G)
        push!(hkk,total_cost(G3))
        println("\nMeilleure tournée trouvée pour "*f)
        G4=hk_prim(G)
        push!(hkp,total_cost(G4))

        if G1.nodes[1].data!=Float64[]
            plot_graph(G1,f*"_rsl_kruskal")
        end
        if G2.nodes[1].data!=Float64[]
            plot_graph(G2,f*"_rsl_prim")
        end
        if G3.nodes[1].data!=Float64[]
            plot_graph(G3,f*"_hk_kruskal")
        end
        if G4.nodes[1].data!=Float64[]
            plot_graph(G4,f*"_hk_prim")
        end
    end

    println("rsl kruskal: ",rk)
    println("rsl prim: ",rp)
    println("hk kruskal: ",hkk)
    println("hk prim: ",hkp)
end

function results(f::String)
    
    G=create_graph(f,"../../instances/stsp/"*f*".tsp")
    if G.nodes[1].data!=Float64[]
        plot_graph(G,f)
    end

    G1=rsl_kruskal(G)
    rk=total_cost(G1)
    G2=rsl_prim(G)
    rp=total_cost(G2)
    G3=hk_kruskal(G)
    hkk=total_cost(G3)
    println("\nMeilleure tournée trouvée pour "*f)
    G4=hk_prim(G)
    hkp=total_cost(G4)

    if G1.nodes[1].data!=Float64[]
        plot_graph(G1,f*"_rsl_kruskal")
    end
    if G2.nodes[1].data!=Float64[]
        plot_graph(G2,f*"_rsl_prim")
    end
    if G3.nodes[1].data!=Float64[]
        plot_graph(G3,f*"_hk_kruskal")
    end
    if G4.nodes[1].data!=Float64[]
        plot_graph(G4,f*"_hk_prim")
    end

    println("rsl kruskal: ",rk)
    println("rsl prim: ",rp)
    println("hk kruskal: ",hkk)
    println("hk prim: ",hkp)
end

test() 
#total() # ATTENTION : Cette fonction calcule le résultats sur TOUTES les instances de tsp disponibles. L'exécution en est TRES longue