
func = @funcb;
eps = 0.0001;
delta = 0.05;
gold = (sqrt(5)+1)/2;

%phase 1
a_l = 0;
a_m = delta;
a_u = delta*gold;
k = 2;

opt = 0;
while opt == 0
    if func(a_u) >= func(a_m)
        opt = 1;
    elseif func(a_m) >= func(a_l)
        a_u = a_m;
        opt = 1;
    elseif func(a_u) < func(a_m)
        a_l = a_m;
        a_m = a_u;
        a_u = a_u + delta*gold^k;
        k = k+1;
    end
end

%phase 2
tau = (-1+sqrt(5))/2;

while a_u-a_l > eps

    a_b = a_l + (a_u-a_l)*tau;
    a_a = a_u - (a_u-a_l)*tau;

    if func(a_a) <= func(a_b)
        a_u = a_b;
    else
        a_l = a_a;
    end

end

%the result
a = (a_u+a_l)/2;

fprintf("The minimum point is:")
a
fprintf("with the cost:")
func(a)
