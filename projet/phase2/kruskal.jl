"""Renvoie la racine du noeud placé en paramètre"""
function find_root(n::Node{T}) where T
    if n.par==n
        return n
    else
        return find_root(n.par)
    end
end

"""Applique l'algorithme Kruskal pour renvoyer un arbre 
de recouvrement minimal du graphe en paramètre"""
function kruskal(graph::Graph{T}) where T
    res=Graph(string("min_tree_",graph.name),graph.nodes,Edge{T}[])
    
    #Réinitialisation des parents des noeuds dans le graphe (pour couvrir une éventuelle application
    #passée de l'algorithme Kruskal sur le graphe)
    for n in graph.nodes
        set_parent!(n,n)
    end

    #Tri des arêtes
    sort!(graph.edges, by=weight)

    for edge in graph.edges
        r1=find_root(edge.limits[1])
        r2=find_root(edge.limits[2])
        if r1!=r2
            r2.par=r1
            push!(res.edges,edge)
        end
    end
    return res
end