function plot_graph(graph::Graph{T}) where T
    nodes=graph.nodes
    edges=graph.edges
    fig = plot(legend=false)
  
    # edge positions
    for edge in edges
        n1=edge.limits[1].data
        n2=edge.limits[2].data
        plot!([n1[1], n2[1]], [n1[2], n2[2]],
            linewidth=1.5, alpha=0.75, color=:lightgray)
      
    end
  
    # node positions
    x = [xy.data[1] for xy in nodes]
    y = [xy.data[2] for xy in nodes]
    scatter!(x, y)
  
    savefig("test.png")
  end