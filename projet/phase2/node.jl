import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
#  par::Node{T}
  data::T
end

Node{T}(data::T) where T = Node("default",data)

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name`, `par` et `data`.

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

#"""Renvoie le parent du noeud"""
#par(node::AbstractNode) = node.par

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node))#, ", parent:", node.par.name)
end
