### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ e27abf2e-ffda-11ea-0f3e-ed473f2ad222
begin
	include("node.jl")
	include("edge.jl")
	include("graph.jl")
	
	A=Node("A","a")
	B=Node("B","b")
	show(A)
	show(B)
	
	AB=Edge([A,B],12)
	show(AB)
	
	G=Graph("G",Node{String}[],Edge{String}[])
	show(G)
	add_node!(G,A)
	add_node!(G,B)
	add_edge!(G,AB)
	show(G) 
end

# ╔═╡ 9bc5a640-ffd5-11ea-0bb2-1b111d33b203
md"# **Rapport de projet MTH6412B phase 1**
*Travail réalisé par Hugo BRETON et Gaël REYNAL*

*Remis au Pr Dominique ORBAN*

*Septembre 2020*
"  

# ╔═╡ 3affd370-ffd6-11ea-1c59-df05188790c4
md"## Implémentation des arêtes ##
On a créé le type *Edge* comme une structure mutable selon le code présent dans le fichier edge.jl. Il dérive du type *AbstractEdge*. On y retrouve les deux caractéristiques d'une arête :
* *limits* est un vecteur de Noeuds de même type T défini lors de la création de l'arête. Il est donc de type *Vector{Node{T}}*
* *weight* est le poids de l'arête, de type *Int64*  
On retrouve également trois méthodes.
* Deux méthodes, *limits(edge::AbstractEdge)* et *weight(edge::AbstractEdge)*, permettant de renvoyer les différents attributs de l'arête paramètre.
* Une méthode d'affichage de l'arête *show(edge::AbstractEdge)* renseignant les noms des noeuds qu'elle relie ainsi que son poids
"

# ╔═╡ e9ccb520-ffd7-11ea-156d-b375ce669b9e
md"## Mise à jour du type *Graph* ##
Un graphe est mathématiquement défini comme la donnée d'un couple $(S,A)$ où $S$ est l'ensemble des sommets et $A \in (S\times S)$ l'ensemble des arêtes du graphe. On a donc repris cette structure en ajoutant au type *Graph* un attribut *edges* qui n'est autre qu'un vecteur d'arêtes de type *Vector{Edge{T}}*.

On a également ajouté au type les méthodes suivantes :
* *add_edge!(graph::AbstractGraph,edge::AbstractEdge)* qui permet d'ajouter une arête au graphe sur le même modèle que la méthode *add_node!*
* *edges(graph::AbstractGraph) qui renvoie l'attribut *edges* du graphe
* *nb_edges(graph::AbstractGraph) qui renvoie le nombre d'arêtes du graphe

On a également modifié la méthode *show* du type pour qu'elle affiche les noeuds et les arêtes du graphe.
"

# ╔═╡ 06c10d4e-ffda-11ea-1f8c-fb2ceb219c90
md"## Tests de la structure de graph
	Afin de vérifier le bon fonctionnement des méthodes et des types que nous avons implémentés, nous proposons le court programme suivant
	"

# ╔═╡ 1f143480-ffdb-11ea-2112-d9ee20702068


# ╔═╡ Cell order:
# ╟─9bc5a640-ffd5-11ea-0bb2-1b111d33b203
# ╟─3affd370-ffd6-11ea-1c59-df05188790c4
# ╟─e9ccb520-ffd7-11ea-156d-b375ce669b9e
# ╠═06c10d4e-ffda-11ea-1f8c-fb2ceb219c90
# ╠═e27abf2e-ffda-11ea-0f3e-ed473f2ad222
# ╠═1f143480-ffdb-11ea-2112-d9ee20702068
