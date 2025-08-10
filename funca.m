function y = funca(a)
%This is homework function from section a

x_k = [-1,-1,-1];
d = [1,3,1];
x = x_k + a*d;
y = (5*x(1) + 3*x(2) + 2*x(3))^2 + 24*(x(1) - x(2))^2;

end