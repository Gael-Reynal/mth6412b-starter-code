import Base.show

mutable struct RankNode{T} <: AbstractNode{T}
    data::T
    name::String
    par::Union{Node{T},Nothing}
    rank::Int
  end

RankNode{T}(data::T;
  name::String="",
  par::Union{Node{T},Nothing}=nothing,
  rank::Int=0) where T = RankNode(data,name,par,rank)

#Un RankNode est un Node avec un attribut rang

"""Renvoie le rang du noeud"""
rank(node::AbstractNode) = node.rank

"""Setter du rang d'un noeud"""
function set_rank!(node::RankNode{T}, r::Int) where T
  node.rank = r
  node
end

"""Affiche un ranknode."""
function show(node::RankNode{T}) where T
  if node.par==nothing
    println("Node ", name(node), ", data: ", data(node), ", parent: ", node.par, ", rang: ", node.rank)
  else
    println("Node ", name(node), ", data: ", data(node), ", parent: ", node.par.name, ", rang: ", node.rank)
  end
end