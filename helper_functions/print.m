function print(a,b,c,d,e,f,g)
	try       message = strcat(a,num2str(b),c,num2str(d),e,num2str(f),g)
	catch try message = strcat(a,num2str(b),c,num2str(d),e,num2str(f))
	catch try message = strcat(a,num2str(b),c,num2str(d),e)
	catch try message = strcat(a,num2str(b),c,num2str(d))
	catch try message = strcat(a,num2str(b),c)
	catch try message = strcat(a,num2str(b))
	catch try message = strcat(a)
	end end end end end end end
end


