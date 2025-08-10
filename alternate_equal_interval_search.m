
func = @funcb;
eps = 0.0001;
delta = 0.05;

%phase 1
a_l = 0;
a_m = a_l + delta;
a_u = a_m + delta;

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
        a_u = a_u + delta;
    end
end

%phase 2
while a_u-a_l > eps

    a_a = a_l + (a_u-a_l)/3;
    a_b = a_u - (a_u-a_l)/3;

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