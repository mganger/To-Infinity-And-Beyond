function s = specAngMom(obj)
	s = sqrt(obj.semiLatus() * obj.bigG * obj.centerMass)
end
