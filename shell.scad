module shell(p,rad, flag=0) {
	hull()
		for (q=p) translate(q) 
			color(flag?"red":"blue")   
				sphere(rad);

}
