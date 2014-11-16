function s = specAngMom(obj)
	s = sqrt(semiLatus(obj) * obj.bigG * obj.centerMass)
end
