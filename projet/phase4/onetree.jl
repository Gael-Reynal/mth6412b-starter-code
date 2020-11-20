function onetree(graph::Graph{T}) where T
    min_cost = Inf
    res=Graph{T}("")

    for n in graph.nodes
        #link contiendra les arêtes reliant le noeud n au reste du graphe
        link = Edge{T}[] 

        #Création du graphe isolant le noeud n
        isol = Graph{T}("")
        for n1 in graph.nodes
            if n1!=n
                add_node!(isol,n1)
            end
        end

        for edge in graph.edges
            if n in edge.limits
                push!(link,edge)
            else
                add_edge!(isol,edge)
            end
        end

        #Recherche des deux arêtes liantes de poids minimaux 
        lowest=minimum(link)
        idx = findall(x -> x == lowest, link)[1]
        e1=link[idx]
        deleteat!(link, idx)

        lowest=minimum(link)
        idx = findall(x -> x == lowest, link)[1]
        e2=link[idx]
        deleteat!(link, idx)
        
        #Recherche du MST
        mst=prim(isol,isol.nodes[1])

        add_edge!(mst,e1)
        add_edge!(mst,e2)
        add_node!(mst,n)

        if total_cost(mst) < min_cost
            min_cost = total_cost(mst)
            res = Graph(graph.name*"_min_1_tree",graph.nodes,Edge{T}[])
            for edge in mst.edges
                add_edge!(res,edge)
            end
        end
    end
    return res
end