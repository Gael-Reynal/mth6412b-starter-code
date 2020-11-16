### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 479b9640-0491-11eb-1edf-7f8e77e7fa47
using PlutoUI

# ╔═╡ 6328f650-0491-11eb-1824-1f2d1ece864f
using Test

# ╔═╡ 6e1cc3c0-0491-11eb-2b92-b39b242fdfaf
include("node.jl")

# ╔═╡ 75edf470-0491-11eb-0063-df96359dfb37
include("edge.jl")

# ╔═╡ 7b2abea0-0491-11eb-2456-bfa532b36446
include("graph.jl")

# ╔═╡ 80e14cb0-0491-11eb-195e-4f6b39b32d23
include("read_stsp.jl")

# ╔═╡ 86bb8f60-0491-11eb-0c33-6f2f7f98d204
include("creategraph.jl")

# ╔═╡ 8e885340-0491-11eb-331c-bfaac1dec9ba
include("kruskal.jl")

# ╔═╡ 94577260-0491-11eb-2523-83bc14984066
include("main.jl")

# ╔═╡ 9934de80-0491-11eb-3bd5-cb20ee9c879e
md"# **Rapport de projet MTH6412B phase 2**
*Travail réalisé par Hugo BRETON et Gaël REYNAL*

*Remis au Pr Dominique ORBAN*

*Octobre 2020*

*code disponible à l'adresse : https://github.com/Gael-Reynal/mth6412b-starter-code.git*
## Composantes connexes d'un graphe
On souhaite implémenter une structure de données qui nous permettra de travailler sur les composantes connexes d'un graphe. On propose d'étendre le type *Node* déjà créé en lui ajoutant un attribut *par* qui correspond à son parent. Cet attribut est de type *Union{Node{T},Nothing}* et est initialisé par défaut à *nothing*.
Outre sa simplicité, ce choix d'implémentation est très efficace. En effet, il s'agit d'établir des 'noeuds de référence' pour les composantes connexes. Ces noeuds sont eux mêmes leurs propre parent : ce sont des racines. Ainsi, pour savoir si deux noeuds sont dans une même composante connexe, il suffit de savoir s'ils ont la même racine en remontant la chaîne des parents.

On peut noter que le parcours se fait dans un seul sens : on va facilement d'un noeud à son parent, mais le sens inverse est impossible. Comme il n'est cependant pas utilisé ici, nul besoin de l'implémenter.

On a donc ajouté l'attribut *par*, ainsi que le getter et le setter correspondants.
"  

# ╔═╡ f823b1f0-0491-11eb-0068-3ba62ab88367
with_terminal() do
	open("node.jl","r") do file
	lines=readlines(file)
		for i in 15:41
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 90fcfff0-0495-11eb-0f16-6bd559781c14
md"## Implémentation de l'algorithme de Kruskal
Pour implémenter cette algorithme de recherche d'un arbre couvrant minimal, nous avons besoin de deux fonctions :
* *find_root(n::Node{T})* qui va renvoyer la racine d'un noeud. On procède récursivement : si le noeud est son propre parent, c'est qu'il s'agit de la racine : on le renvoie. sinon, on renvoie la racine du parent en question. Cette méthode a une complexité dans le pire cas en $\Theta(n)$ mais dépend de la façon dont sont affectés les parents au sein d'une même composante connexe.
"

# ╔═╡ 5c59da10-0496-11eb-387a-3d571cf25623
with_terminal() do
	open("kruskal.jl","r") do file
	lines=readlines(file)
		for i in 1:8
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 5d17f9f0-0496-11eb-152b-2f85db56f2cb
md"* *kruskal(graph::Graph{T})* qui va appliquer l'algorithme de recherche de Kruskal sur le graphe. On commence par créer un graphe résultat dont l'ensemble des noeuds est identique à celui du graphe paramètre et dont l'ensemble des arêtes est vide. On réinitialise ensuite tous les parents des noeuds du graphe : chaque noeud devient son propre parent et forme une composante connexe isolée. Puis, on trie les arêtes du graphe par ordre croissant de poids. Enfin, on parcourt l'ensemble des arêtes : si ses deux extrémités sont dans deux composantes connexes différentes, on ajoute l'arête au graphe résultat. Cette méthode a une complexité en $O(A\log A)$ avec $A$ le nombre d'arêtes du graphe, du fait de la domination de l'étape de tri des arêtes dans la complexité.
"

# ╔═╡ 76610f50-0496-11eb-11d5-a9bc454454d0
with_terminal() do
	open("kruskal.jl","r") do file
	lines=readlines(file)
		for i in 10:33
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ a6266900-0497-11eb-39ab-63e92c5f5f1c
md"## Tests
Afin de vérifier la validité de notre implémentation, on propose le programme suivant :
"

# ╔═╡ 2891b570-0498-11eb-1385-1317ebc3456a
with_terminal() do
	#Exemple facilitant les tests unitaires

	A=Node("a","A",nothing)
	B=Node("b","B",nothing)
	C=Node("c","C",nothing)
	D=Node("d","D",nothing)
	E=Node("e","E",nothing)
	F=Node("f","F",nothing)
	set_parent!(A,A)
	set_parent!(B,A)
	set_parent!(C,B)
	set_parent!(D,B)
	set_parent!(E,E)
	set_parent!(F,E)

	println("Test de find_root\n")
	println(@test find_root(A)==A)
	println(@test find_root(B)==A)
	println(@test find_root(C)==A)
	println(@test find_root(F)==E)
	println("\n")
	
	AB=Edge([A,B],1)
	AD=Edge([A,D],1)
	BC=Edge([B,C],1)
	CD=Edge([C,D],1)
	AC=Edge([A,C],10)
	BD=Edge([B,D],10)

	g=Graph("g",[A,B,C,D],[AC,AD,BC,CD,AB,BD])
	show(g)
	println("\nAlgorithme de Kruskal")

	#On s'attend à ce que l'algorithme du Kruskal renvoie un graphe à 3 arêtes parmi AB, AD, BC et CD
	min_g=kruskal(g)
	println(@test length(min_g.edges)==3)
	for e in min_g.edges
		println(@test in(e,(AB,AD,BC,CD)))
	end
	println("\n")
	show(min_g)
	println("\n")

	println("Exemple des notes de cours")
	A=Node("a","A",nothing)
	B=Node("b","B",nothing)
	C=Node("c","C",nothing)
	D=Node("d","D",nothing)
	E=Node("e","E",nothing)
	F=Node("f","F",nothing)
	G=Node("g","G",nothing)
	H=Node("h","H",nothing)
	I=Node("i","I",nothing)

	AB=Edge([A,B],4)
	AH=Edge([A,H],8)
	BH=Edge([B,H],11)
	BC=Edge([B,C],8)
	HI=Edge([H,I],7)
	HG=Edge([H,G],1)
	IG=Edge([I,G],6)
	IC=Edge([I,C],2)
	CD=Edge([C,D],7)
	CF=Edge([C,F],4)
	GF=Edge([G,F],2)
	DF=Edge([D,F],14)
	DE=Edge([D,E],9)
	EF=Edge([E,F],10)

	g2=Graph("g2",[A,B,C,D,E,F,G,H,I],[AB,AH,BH,BC,HI,HG,IG,IC,CD,CF,GF,DF,DE,EF])
	show(g2)
	println("\nRecherche d'arbre couvrant minimal")
	show(kruskal(g2))
end

# ╔═╡ 86be54e0-0499-11eb-33a6-53466782a496
md"A toutes fins utiles, on a également testé le programme sur deux instances de cours (avec et sans données de noeuds)
"

# ╔═╡ a4cd7dd0-0499-11eb-049b-375e8edca5fa
with_terminal() do
	fic1 = "../../instances/stsp/bays29.tsp" 
	fic2 = "../../instances/stsp/bayg29.tsp"

	graph_braz = create_graph("g1", fic1)
	graph_bayg = create_graph("g2", fic2)

	println("\n Bayg29")
	show(kruskal(graph_bayg))
	println("\n Brazil58")
	show(kruskal(graph_braz))
end

# ╔═╡ Cell order:
# ╠═479b9640-0491-11eb-1edf-7f8e77e7fa47
# ╠═6328f650-0491-11eb-1824-1f2d1ece864f
# ╠═6e1cc3c0-0491-11eb-2b92-b39b242fdfaf
# ╠═75edf470-0491-11eb-0063-df96359dfb37
# ╠═7b2abea0-0491-11eb-2456-bfa532b36446
# ╠═80e14cb0-0491-11eb-195e-4f6b39b32d23
# ╠═86bb8f60-0491-11eb-0c33-6f2f7f98d204
# ╠═8e885340-0491-11eb-331c-bfaac1dec9ba
# ╠═94577260-0491-11eb-2523-83bc14984066
# ╠═9934de80-0491-11eb-3bd5-cb20ee9c879e
# ╠═f823b1f0-0491-11eb-0068-3ba62ab88367
# ╟─90fcfff0-0495-11eb-0f16-6bd559781c14
# ╟─5c59da10-0496-11eb-387a-3d571cf25623
# ╟─5d17f9f0-0496-11eb-152b-2f85db56f2cb
# ╟─76610f50-0496-11eb-11d5-a9bc454454d0
# ╟─a6266900-0497-11eb-39ab-63e92c5f5f1c
# ╠═2891b570-0498-11eb-1385-1317ebc3456a
# ╟─86be54e0-0499-11eb-33a6-53466782a496
# ╠═a4cd7dd0-0499-11eb-049b-375e8edca5fa
