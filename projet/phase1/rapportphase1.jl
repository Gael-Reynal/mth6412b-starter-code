### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 17de7f90-0193-11eb-3189-ab97dad3702c
using PlutoUI

# ╔═╡ 0d1eabb0-0199-11eb-0ea6-4f0582150483
using Test

# ╔═╡ 3c82afb0-0193-11eb-2e00-c146bf01d9c1
include("node.jl")

# ╔═╡ 3c8324e0-0193-11eb-002a-2969488bc635
include("edge.jl")

# ╔═╡ 3c83c120-0193-11eb-0e18-0be080be29c4
include("graph.jl")

# ╔═╡ 32ab4ec0-0193-11eb-0912-19580b53ce5c
include("read_stsp.jl")

# ╔═╡ 27c5f180-0199-11eb-19ad-07a7b76406a2
include("main.jl")

# ╔═╡ 9bc5a640-ffd5-11ea-0bb2-1b111d33b203
md"# **Rapport de projet MTH6412B phase 1**
*Travail réalisé par Hugo BRETON et Gaël REYNAL*

*Remis au Pr Dominique ORBAN*

*Septembre 2020*

*code disponible à l'adresse : https://github.com/Gael-Reynal/mth6412b-starter-code.git
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
* *edges(graph::AbstractGraph)* qui renvoie l'attribut *edges* du graphe
* *nb_edges(graph::AbstractGraph)* qui renvoie le nombre d'arêtes du graphe

On a également modifié la méthode *show* du type pour qu'elle affiche les noeuds et les arêtes du graphe.
"

# ╔═╡ 06c10d4e-ffda-11ea-1f8c-fb2ceb219c90
md"## Tests de la structure de graph

Afin de vérifier le bon fonctionnement des méthodes et des types que nous avons implémentés, nous proposons le court programme suivant
	"

# ╔═╡ e27abf2e-ffda-11ea-0f3e-ed473f2ad222
with_terminal() do
	
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

# ╔═╡ 1f143480-ffdb-11ea-2112-d9ee20702068
md"## Prise en compte du poids des arêtes
Afin de prendre en compte le poids des arêtes, on a modifié la fonction *read_edges* afin de récupérer les coefficients des lignes du fichier .tsp avec la commande *w=parse(data[j+1])* où *w* est le poids à récupérer, *data* un tableau comprenant la liste des coefficients de la ligne et j un entier décrivant l'avancement du traitement de la ligne. Une fois ce poids récupéré, il n'y a plus qu'à l'implémenter avec l'arête qu'on stocke dans un premier temps sous la forme *(i,j,w)* avec i et j les noms des noeuds reliés par l'arête et w le poids, comme visible ci-dessous
"

# ╔═╡ 2a0e1640-fff8-11ea-2484-67353cdfb25b
with_terminal() do
	open("read_stsp.jl","r") do file
	lines=readlines(file)
		for i in 131:147
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ d93ff0c0-fff8-11ea-1f36-654756118ef9
md"## Lecture d'un fichier TSP et conversion en graphe
A présent que nous sommes capables de récupérer les données d'un fichier TSP au format EXPLICIT, nous pouvons créer l'objet de type *Graph* qui y correspond.
A partir du dictionnaire des noeuds, on crée la liste des noeuds. On parcourt l'intégralité des clés du dictionnaire. Avec la commande *string()* on transforme ces clés (en général des entiers) en chaînes de caractère de façon à obtenir l'attribut *name*. Puis, les données correspondant à la clé (en général un tableau de deux flottants représentant les coordonnées) sont stockées dans l'attribut *data*.
On a également la liste des arêtes sous la forme de triplets $(i,j,w)$ avec $i$ et $j$ les noms des noeuds reliés par l'arêtes. Deux options s'offrent alors à nous :
* Soit on implémente les arêtes en utilisant pour l'attribut limits un *Vector{String}* comportant les noms des noeuds. Cependant, l'arête ne lie pas alors deux noeuds, mais deux chaînes de caractères qui devront ensuite être reliées à des noeuds. Ainsi, si des noeuds du Graphe viennent à changer de nom, les arêtes ne seront plus valides. Cette solution n'a pas été retenue.
* On utilise la fonction *find\_node\_of\_name(graph::Graph,name::String)* qui recherche dans les noeuds du graph le noeud de nom correspondant. En appliquant cette fonction aux noeuds $i$ et $j$, on obtient un *Vector{Node{T}* qui devient l'attribut *limits* de l'arête. Ainsi, tout changement opéré sur les noeuds, même un changement de nom, sera répercuté sur les arêtes qui les concernent. De plus, si suite à une erreur, un noeud au nom déjà utilisé par un autre est ajouté au graphe, cela n'aura aucune incidence sur les arêtes comme cela en aurait eu si on s'était simplement reposé sur une correspondance entre les noms des noeuds et les noeuds eux-mêmes pour établir les limites des arêtes et effectuer des calculs sur le graphe. On a donc privilégié cette méthode. Le poids est quant à lui intégré tel quel dans l'arête.
La fonction *create_graph(name::String,filename::String)* va donc, à partir d'un fichier tsp de nom *filename*, créer un graphe de nom *name* comme décrit ci-dessous.
"

# ╔═╡ 198bf690-0195-11eb-3d5a-7bfdee394511
with_terminal() do
	open("main.jl","r") do file
	lines=readlines(file)
		for i in 45:75
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 4463fb10-0195-11eb-3248-b1558a125c9d
md"Les tests suivants permettent de s'assurer de la bonne construction de la structure de graphe pour quelques exemples"

# ╔═╡ ec1359c0-0198-11eb-0970-5bd6665738b6
with_terminal() do
	fic1 = "../../instances/stsp/brazil58.tsp" 
	fic2 = "../../instances/stsp/swiss42.tsp"
	fic3 = "../../instances/stsp/gr21.tsp"

	graph_braz = create_graph("g", fic1)
	graph_swiss = create_graph("g", fic2)
	graph_groet = create_graph("g", fic3)

	println(@test typeof(graph_braz) == Graph{Array{Float64, 1}})
	println(@test nb_nodes(graph_braz) == 58)
	println(@test nb_edges(graph_braz) == 58*57/2)

	println(@test typeof(graph_swiss) == Graph{Array{Float64, 1}})
	println(@test nb_nodes(graph_swiss) == 42)
	println(@test nb_edges(graph_swiss) == 42*42)

	println(@test typeof(graph_groet) == Graph{Array{Float64, 1}})
	println(@test nb_nodes(graph_groet) == 21)
	println(@test nb_edges(graph_groet) == 22*21/2)

	g=create_graph("g","../../instances/stsp/bayg29.tsp")
	show(g)
end

# ╔═╡ Cell order:
# ╠═17de7f90-0193-11eb-3189-ab97dad3702c
# ╠═0d1eabb0-0199-11eb-0ea6-4f0582150483
# ╠═3c82afb0-0193-11eb-2e00-c146bf01d9c1
# ╠═3c8324e0-0193-11eb-002a-2969488bc635
# ╠═3c83c120-0193-11eb-0e18-0be080be29c4
# ╠═32ab4ec0-0193-11eb-0912-19580b53ce5c
# ╠═27c5f180-0199-11eb-19ad-07a7b76406a2
# ╠═9bc5a640-ffd5-11ea-0bb2-1b111d33b203
# ╟─3affd370-ffd6-11ea-1c59-df05188790c4
# ╟─e9ccb520-ffd7-11ea-156d-b375ce669b9e
# ╟─06c10d4e-ffda-11ea-1f8c-fb2ceb219c90
# ╟─e27abf2e-ffda-11ea-0f3e-ed473f2ad222
# ╟─1f143480-ffdb-11ea-2112-d9ee20702068
# ╟─2a0e1640-fff8-11ea-2484-67353cdfb25b
# ╟─d93ff0c0-fff8-11ea-1f36-654756118ef9
# ╟─198bf690-0195-11eb-3d5a-7bfdee394511
# ╟─4463fb10-0195-11eb-3248-b1558a125c9d
# ╟─ec1359c0-0198-11eb-0970-5bd6665738b6
