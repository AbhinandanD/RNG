import os
import sys
import zen
current_file=sys.argv[1]
#print current_file
A =zen.io.edgelist.read(current_file, node_obj_fxn=str, directed=True, ignore_duplicate_edges=False, merge_graph=None, weighted=True)
Path = (zen.algorithms.shortest_path.all_pairs_dijkstra_path(A, ignore_weights=False))
pathLength=2
foutput="sh_paths_"+current_file
output=open("%s"%foutput,'w')
for n1 in A.nodes():
	for n2 in A.nodes():
		if n1 != n2 and Path[n1][n2][0] != float('inf'):
			trace = (zen.algorithms.shortest_path.pred2path(n1, n2, Path))
			if len(trace)>pathLength:
				tracepath=""
				for k in range(len(trace)):
					tracepath=tracepath+trace[k]+","
					normps=float(Path[n1][n2][0])/float(len(trace)-1)
				output.write("%s"%tracepath[:-1]+"\t%s\n"%str(normps))
				tracepath=""
output.close()
