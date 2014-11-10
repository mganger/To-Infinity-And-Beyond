clear all; clc; close all; format long eng; more off; 
addpath('helper_functions')

for i = 0:15
	for j = 0:20
		for k = 0:20
			theta_d = (i+(j/10.0))*pi
			theta_a = theta_d + (k/10.0)*pi
			Mars_Project(theta_a, theta_d)
			'--------------------------'
		end
	end
end


