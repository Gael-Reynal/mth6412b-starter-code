import Base.show

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        arête = Edge((Node1, Node2), 12)

"""
mutable struct Edge{T} <: AbstractEdge{T}
  parents::T                                #Destiné à être un tuple de noeuds
  weight::Int64                                
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `name` et `parents`.

"""Renvoie le nom du noeud."""
parents(edge::AbstractEdge) = edge.parents

"""Renvoie les données contenues dans le noeud."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche un noeud."""
function show(edge::AbstractEdge)
  println("Parents: ", parents(edge),", weight: ", weight(edge))
end
