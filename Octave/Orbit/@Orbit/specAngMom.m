%return the specific angular momentum of a given orbit
function s = specAngMom(obj)
	s = sqrt(semiLatus(obj) * obj.bigG * obj.centerMass)
end
