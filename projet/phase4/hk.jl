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

"""Applique l'algorithme de Held et Karp sur le graphe passé en paramètre."""
function hk(graph::Graph{T}) where T
    
    ###Initialisation
    #Résultat
    mst=Graph{T}("")
    #Période
    per=div(length(graph.nodes),2)
    k=0
    #Pas
    t=1
    #Booléen traduisant une augmentation de W à une itération donnée
    aug=false
    #Booléen de la série d'augmentation de W de la première période
    firstper=true

    W=-Inf
    for n in graph.nodes
        set_pen!(n,0)
    end
    

    while per>0 && t>0
        # Prise en compte des pénalités
        for edge in graph.edges
            set_weight!(edge,edge.weight+edge.limits[1].pen+edge.limits[2].pen)
        end

        # Recherche du 1-Tree minimal
        mst=onetree(graph)

        #Calcul de w(pi_k)
        wpik=total_cost(mst)-2*sum(n.pen for n in mst.nodes)
        
        #Mise à jour de W
        if wpik > W
            aug = true
            W = wpik
        else
            aug = false
            firstper = false
        end

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
            for n in graph.nodes
                set_pen!(n, n.pen+n.deg*t)
            end
            k+=1
            
            #Durant la première période
            if firstper
                t=t*2
            end

            #Si une période est finie, on divise par 2 le pas et la période
            if k==per
                k=0
                if aug
                    per=per*2
                else
                    per=div(per,2)
                end
                t=t/2
                firstper=false
            end
        end
        println("t: ",t," per: ",per," poids: ",total_cost(mst))
    end

    #Si on n'a encore rien renvoyé, on crée le graphe résultat et on le renvoie
    tournee=preorder(mst,mst.nodes[1])
    res=Graph(graph.name*"_min_tsp",graph.nodes,Edge{T}[])

    for k in 1:length(tournee)-1
        n1=tournee[k]
        n2=tournee[k+1]
        found=false
        e=1
        while !found
            edge=graph.edges[e]
            if edge.limits==[n1,n2] || edge.limits==[n2,n1]
                add_edge!(res,edge)
                found=true
            end
            e+=1
        end
    end
    n1=tournee[1]
    n2=tournee[length(tournee)]
    found=false
    e=1
    while !found
        edge=graph.edges[e]
        if edge.limits==[n1,n2] || edge.limits==[n2,n1]
            add_edge!(res,edge)
            found=true
        end
        e+=1
    end
    return res
end