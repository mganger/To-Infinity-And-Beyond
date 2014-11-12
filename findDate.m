clear all; clc; close all; format long eng; more off; 
addpath('helper_functions')

%file = fopen('file.txt', 'w')

for j = 0:320
	for k = 0:20
		theta_d = (j/10.0)*pi
%		strcat(num2str(j/10),',',num2str(k))
		theta_a = theta_d + (k/10.0)*pi
		try
			outcome = Mars_Project(theta_a, theta_d);
		'--------------------------'
			save('-append','file.txt','outcome')
       		catch
			continue;
		end
	end
end


