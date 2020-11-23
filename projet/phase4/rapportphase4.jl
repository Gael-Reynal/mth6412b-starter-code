### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ dd791470-2cd8-11eb-36b3-df89c926caf2
using PlutoUI

# ╔═╡ e9545bb0-2cd8-11eb-1296-274a4d1b3884
using Test

# ╔═╡ bdd20a80-2c35-11eb-2975-c159b73b2e02
begin
	include("node.jl")
	include("edge.jl")
	include("graph.jl")
	include("queue.jl")
	include("heuristics.jl")
	include("prim.jl")
	include("kruskal.jl")
	include("creategraph.jl")
	include("read_stsp.jl")
	include("onetree.jl")
	include("rsl.jl")
	include("hk.jl")
	include("graphplot.jl")
end

# ╔═╡ a3764ca0-2c35-11eb-3a93-cbf8de88d3fd
md"# **Rapport de projet MTH6412B phase 4**
*Travail réalisé par Hugo BRETON et Gaël REYNAL*

*Remis au Pr Dominique ORBAN*

*Novembre 2020*

*code disponible à l'adresse : https://github.com/Gael-Reynal/mth6412b-starter-code.git*

## Remarque préliminaire

On a ajouté au noeuds un attribut de pénalité pour faciliter l'implémentation de l'algorithme hk.

## Recherche de 1-tree

On a implémenté comme suit la recherche d'un 1-tree de poids minimal pour un graphe. Il s'agit simplement de construire tous les 1-tree issus de l'isolation d'un des noeuds du graphe et de sélectionner le meilleur. La version présentée ici utilise l'algorithme de prim. Pour la version avec l'algorithme de kruskal, seule la ligne `l37` change.
"



# ╔═╡ d28769e0-2cd8-11eb-34e4-9fca3673a515
with_terminal() do
	open("onetree.jl","r") do file
	lines=readlines(file)
		for i in 1:52
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 159bf2d0-2c36-11eb-3bc9-7d95315dd23f
md"## Algorithme RSL

On a implémenté comme suit deux versions de l'algorithme RSL. L'une fonctionne avec l'algorithme de kruskal, l'autre avec l'algorithme de prim. De même que précédemment, la version présentée ici utilise l'algorithme de prim. pour la version avec l'algorithme de kruskal, on modifie la ligne `l17`.
"

# ╔═╡ 3d4ca290-2cd9-11eb-0662-7b48feba5bc8
with_terminal() do
	open("rsl.jl","r") do file
	lines=readlines(file)
		for i in 1:44
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 306acb90-2c3b-11eb-1d48-972b1405cd6c
md"## Algorithme HK
On a également implémenté deux versions de l'algorithme HK en utilisant l'algorithme de prim et l'algorithme de Kruskal. On adopte la méthode suivante :
* On adopte un pas constant sur toute la durée d'une période
* A chaque itération $k$, si elle marque la fin d'une période, le pas est divisé par 2
* A chaque itération $k$, on calcule $W_k = max(W_{k-1}, total\_cost(T\pi_k)-\sum_i\pi_i)$ avec T\pi_k le 1-tree calculé à l'itération $k$ en tenant compte des pénalités. Si cette itération marque la fin d'une période et que $W=W_{k-1}$, la période est divisée par $2$. Sinon, la période est multipliée par $2$
* Durant la première période, tant que $W_k$ augmente, on double le pas. A la première itération sans augmentation, le pas reste constant jusqu'à la fin de la période.
* Le pas initial est de $1$ et la période initiale de $n/2$ avec $n$ le nombre de villes
* L'algorithme s'arrête quand tous les noeuds d'un 1-tree sont de degré $2$ ou lorsque le pas est inférieur à $10^{-6}$ ou que la période sont nuls.

On raisonnera donc à chaque itération en plusieurs étapes :
* Recherche du 1-tree de poids minimal
* Calcul du vecteur subgradient
* S'il est nul, on renvoie le 1-tree en question, sinon on met à jour la période et le pas.

Dans le cas où l'algorithme s'arrête pour cause de période ou de pas, on n'obtient pas réellement une tournée. On applique alors un parcours en préordre du dernier 1-tree calculé. 

On a donc implémenté l'algorithme comme suit. Encore une fois, on présente ici la version utilisant l'algorithme de Prim. Pour l'algorithme de Kruskal, modifier la ligne `l44`.
"

# ╔═╡ c16e78a0-2cd9-11eb-2766-6dd26415fa91
with_terminal() do
	open("hk.jl","r") do file
	lines=readlines(file)
		for i in 1:139
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 3f257aa0-2d70-11eb-0b94-8d4dee0c6d9c
md"## Tests
Afin de vérifier la validité de l'implémentation, les tests suivants ont été réalisés :
"

# ╔═╡ 53e20300-2d70-11eb-04c8-f3ba32f8d596
with_terminal() do
	open("hk.jl","r") do file
	lines=readlines(file)
		for i in 1:93
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 5df163e0-2d70-11eb-19ab-53c42de26275
with_terminal() do
	function poids_tournee(graph::Graph{T}) where T
		poids_total = 0
		for edge in graph.edges
			poids_total = poids_total + edge.weight
		end
		poids_total
	end

	function test()

		A=Node("a","A",nothing,Inf,0,0)
		B=Node("b","B",nothing,Inf,0,0)
		C=Node("c","C",nothing,Inf,0,0)
		D=Node("d","D",nothing,Inf,0,0)

		AB=Edge([A,B],2)
		AC=Edge([A,C],8)
		AD=Edge([A,D],4)
		BD=Edge([B,D],4)
		BC=Edge([B,C],3)
		DC=Edge([D,C],4)

		g=Graph("",[A,B,C,D],[AB,AC,BC])
		g1=Graph("g",[A,B,C,D],[AB,AC,BC,BC,BD,DC])

		# Test de la fonction find_deg
		println("Test de find_deg")
		println(@test find_deg(g,A)==2)
		println(@test find_deg(g,D)==0)

		# Test 1  : Sur un exemple simple ---------------------------------------------------

		A=Node("a","A",nothing,Inf,0,0)
		B=Node("b","B",nothing,Inf,0,0)
		C=Node("c","C",nothing,Inf,0,0)
		D=Node("d","D",nothing,Inf,0,0)
		E=Node("e","E",nothing,Inf,0,0)
		F=Node("f","F",nothing,Inf,0,0)
		G=Node("g","G",nothing,Inf,0,0)
		H=Node("h","H",nothing,Inf,0,0)

		AB=Edge([A,B],2)
		AC=Edge([A,C],8)
		AF=Edge([A,F],3)
		AD=Edge([A,D],4)
		CD=Edge([C,D],2)
		BC=Edge([B,C],3)
		BD=Edge([B,D],5)
		BE=Edge([B,E],4)
		CF=Edge([C,F],7)
		DE=Edge([D,E],4)
		EF=Edge([E,F],2)

		graph_1=Graph("G",[A,B,C,D,E,F],[AB,AC,AF,AD,CD,CF,BC,BD,BE,EF,DE])

		tournee1_hk = hk_prim(graph_1)
		tournee1_rsl_prim = rsl_prim(graph_1)
		tournee1_rsl_kruskal = rsl_kruskal(graph_1)

		println(@test total_cost(tournee1_hk)<20)
		println(@test total_cost(tournee1_rsl_prim)<20)
		println(@test total_cost(tournee1_rsl_kruskal)<20)

		# Test 2  : Sur des instances stsp ------------------------------------------------
		repertoire = "../../instances/stsp"

			# Sur bays29 -> Poids min = 2020

		fic1 = string(repertoire,"/bays29.tsp")
		graph_2 = create_graph("graph2", fic1)

		tournee2_hk = hk_prim(graph_2)
		tournee2_rsl_prim = rsl_prim(graph_2)
		tournee2_rsl_kruskal = rsl_kruskal(graph_2)

		println(@test total_cost(tournee2_hk)<4040)
		println(@test total_cost(tournee2_rsl_prim)<4040)
		println(@test total_cost(tournee2_rsl_kruskal)<4040)


			 # Sur bays29 -> Poids min = 2020

		fic1 = string(repertoire,"/bays29.tsp")
		graph_2 = create_graph("graph2", fic1)

		tournee2_hk = hk_prim(graph_2)
		tournee2_rsl_prim = rsl_prim(graph_2)
		tournee2_rsl_kruskal = rsl_kruskal(graph_2)

		println(@test total_cost(tournee2_hk)<4040)
		println(@test total_cost(tournee2_rsl_prim)<4040)
		println(@test total_cost(tournee2_rsl_kruskal)<4040)
	end
	
	test()
end

# ╔═╡ 111885c0-2cb3-11eb-020b-3b7e122adfd4
md"## Comparaison des algorithmes
Pour les quelques instances de tsp symétriques pour lesquelles des coordonnées de point ont été données, on a représenté graphiquement les tournées obtenues par les différents algorithmes.

On a dressé les résultats des algorithmes sur les différentes instances dans le fichier texte `résultats.txt`.
Les meilleurs résultats sont obtenus par combinaison de l'algorithme HK avec celui de Prim (pour la recherche des Arbres de Recouvrement Minimaux). A quelques exceptions près, l'algorithme parvient à trouver une tournée dont le coût est entre 10 et 15% supérieur à celui de l'optimum, et ce en des temps très raisonnables pour d'assez grandes instances (de l'ordre de la minute pour les instances jusqu'à une taille de 50 villes, de l'ordre de l'heure pour des instances jusqu'à 200 villes). 

A toutes fins utiles, une fonction `results` a été implémentée dans le fichier `main.jl`. Elle prend en paramètre un nom de fichier (sans extension) et renvoie les résultats pour les différents algorithmes ainsi que les graphiques des tournées obtenues si les coordonnées des noeuds sont renseignées.
"

# ╔═╡ Cell order:
# ╟─dd791470-2cd8-11eb-36b3-df89c926caf2
# ╟─e9545bb0-2cd8-11eb-1296-274a4d1b3884
# ╟─bdd20a80-2c35-11eb-2975-c159b73b2e02
# ╟─a3764ca0-2c35-11eb-3a93-cbf8de88d3fd
# ╟─d28769e0-2cd8-11eb-34e4-9fca3673a515
# ╟─159bf2d0-2c36-11eb-3bc9-7d95315dd23f
# ╟─3d4ca290-2cd9-11eb-0662-7b48feba5bc8
# ╟─306acb90-2c3b-11eb-1d48-972b1405cd6c
# ╟─c16e78a0-2cd9-11eb-2766-6dd26415fa91
# ╟─3f257aa0-2d70-11eb-0b94-8d4dee0c6d9c
# ╟─53e20300-2d70-11eb-04c8-f3ba32f8d596
# ╟─5df163e0-2d70-11eb-19ab-53c42de26275
# ╟─111885c0-2cb3-11eb-020b-3b7e122adfd4
