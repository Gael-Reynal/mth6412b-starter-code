include("node.jl")
include("edge.jl")
include("graph.jl")
include("queue.jl")
include("heuristics.jl")
include("prim.jl")
include("kruskal.jl")
include("creategraph.jl")
include("read_stsp.jl")
include("rsl.jl")
include("graphplot.jl")

"""Calcule le degré d'un noeud dans un graphe"""
function find_deg(graph::AbstractGraph,node::AbstractNode)
    if !(node in graph.nodes)
        error("Le noeud n'est pas dans le graphe")
    end
    d=0
    for edge in graph.edges
        if node in edge.limits
            d+=1
        end
    end
    return d
end

function step(k::Int)
    return 1/(k+1)
end

function hk(graph::Graph{T},maxiter::Int) where T
    
    #Initialisation
    k=0
    W=-Inf
    for n in graph.nodes
        set_pen!(n,0)
    end

    while k<=maxiter
        # Prise en compte des pénalités
        for edge in graph.edges
            set_weight!(edge,edge.weight+edge.limits[1].pen+edge.limits[2].pen)
        end

        # Recherche du 1-Tree minimal
        mst=onetree(graph)

        #Calcul de w(pi_k)
        wpik=total_cost(mst)-2*sum(n.pen for n in mst.nodes)
        
        #Mise à jour de W
        W=max(W,wpik)

        #Retour à la normale des arêtes
        for edge in graph.edges
            set_weight!(edge,edge.weight-edge.limits[1].pen-edge.limits[2].pen)
        end

        #Calcul du vecteur subgradient
        arret=true
        for n in graph.nodes
            dk=find_deg(mst,n)
            set_deg!(n,dk-2)
            if n.deg!=0
                arret=false
            end
        end

        #Si vk = 0, on renvoie le 1-tree, qui est alors une tournée optimale. Sinon, on met à jour
        if arret
            return mst
        else
            t=step(k)
            for n in graph.nodes
                set_pen!(n, n.pen+n.deg*t)
            end
            k+=1
        end
    end 
    return preorder(graph,graph.nodes[1])
end