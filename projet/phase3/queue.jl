import Base.length, Base.push!, Base.popfirst!
import Base.show
import Base.maximum

"""Type abstrait dont d'autres types de files dériveront."""
abstract type AbstractQueue{T} end

"""Type représentant une file avec des éléments de type T."""
mutable struct Queue{T} <: AbstractQueue{T}
    items::Vector{T}
end

Queue{T}() where T = Queue(T[])

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.items, item)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.items)

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q.items) == 0

"""Donne le nombre d'éléments sur la file."""
length(q::AbstractQueue) = length(q.items)

"""Affiche une file."""
show(q::AbstractQueue) = show(q.items)

"""File de priorité."""
mutable struct PriorityQueue{T <: AbstractPriorityItem} <: AbstractQueue{T}
    items::Vector{T}
end

PriorityQueue{T}() where T = PriorityQueue(T[])

maximum(q::AbstractQueue) = maximum(q.items)

"""renvoie l'élément de plus haute priorité et le retire de la file"""
function popfirst_max!(q::AbstractQueue)
    highest=maximum(q)
    idx = findall(x -> x == highest, q.items)[1]
    highest=q.items[idx]
    deleteat!(q.items, idx)
    highest
end

"""Insère l'objet `item` à la bonne place dans une file de priorité triée"""
function push_sort!(q::PriorityQueue,item)
    push!(q,item)
    n = length(q.items)
    while n>1 && q.items[n-1].priority > item.priority
        q.items[n]=q.items[n-1]
        q.items[n-1]=item
        n-=1
    end
    q
end

"""Affiche une file de priorité"""
function show(q::PriorityQueue)
    println("La file comporte ",length(q.items)," éléments.")
    for k in q.items
        println("L'objet ",k.data," est dans la file avec une priorité de ",k.priority)
    end
end