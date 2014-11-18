test:
	octave rewrite.m
graph.pdf: rewrite.m
	octave rewrite.m
	echo '--------------------------------------------'

