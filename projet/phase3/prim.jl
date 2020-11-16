"""Applique l'algorithme de prim sur le graphe passé en paramètre 
en considérant le noeud passé en paramètre comme source
Ici, l'attribut `value` d'un noeud correspondra au poids de l'arête de poids minimal
le reliant au sous arbre
Réalise également la compression des chemins lors de l'ajout d'un noeud à l'arbre"""
function prim(graph::Graph{T}, source::Node{T}) where T

    #Liste des noeuds encore à visiter
    to_visit = PriorityQueue(Node{T}[])

    #Initialisation du graphe résultat
    tree=Graph(graph.name*"_min_prim",Node{T}[],Edge{T}[])

    #Initialisation des attributs (parent à nothing, value à Inf)
    for n in graph.nodes
        set_parent!(n,nothing)
        set_value!(n,Inf)
        push!(to_visit,n)
        add_node!(tree,n)
    end

    #Initialisation des paramètres de la source
    set_value!(source,0)
    set_parent!(source,source)
    
    #Sortie de la source
    popfirst_min!(to_visit)
    
    #On itère jusqu'à ce qu'il n'y ait plus de noeuds à visiter
    while !(is_empty(to_visit))
        
        for edge in graph.edges
            n1 = edge.limits[1]
            n2 = edge.limits[2]
            r1 = find_root(n1)
            r2 = find_root(n2)

            #On cherche une arête légère reliant un noeud isolé au sous-arbre
            if r1 == source && r2 != source && edge.weight < n2.value
                set_value!(n2,edge.weight)
            elseif r2 == source && r1 != source&& edge.weight < n1.value
                set_value!(n1,edge.weight)
            end
        end

        new_node = popfirst_min!(to_visit)
        
        for edge in graph.edges
            n1 = edge.limits[1]
            n2 = edge.limits[2]
            if n1==new_node && edge.weight==n1.value && find_root(n2)==source
                add_edge!(tree,edge)
                set_parent!(n1,n2)
                break
            elseif n2==new_node && edge.weight==n2.value && find_root(n1)==source
                add_edge!(tree,edge)
                set_parent!(n2,n1)
                break
            end
        end
    end
    return tree
end