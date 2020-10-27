"""fusionne les composantes composantes connexes dont font partie deux noeuds en appliquant
l'union via le rang et la compression des chemins"""
function rank_merge(n1::RankNode{T}, n2::RankNode{T}) where T
    r1=find_root_compressed(n1)
    r2=find_root_compressed(n2)
    if r1 == r2
        return 
    elseif r1.rank == r2.rank
        set_rank!(r1,r1.rank+1)
        set_parent!(r2,r1)
        return r1
    elseif r1.rank > r2.rank
        set_parent!(r2,r1)
        return r1
    else
        set_parent!(r1,r2)
        return r2
    end
end