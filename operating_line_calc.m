function y = operating_line_calc(x,L,V,xB,xD,z,q,feedslope,feedintercept)

%top line
tslope = L/V;
tintercept = (1-(L/V))*xD;

%bottom line
bslope = ((tslope*z+tintercept)-xB)/(z-xB);
bintercept = -(bslope-1)*xB;
%IF q =/ 1
if q ~= 1
% top operating line
f = @(x) tslope*x + tintercept;
%feed line
g = @(x) feedslope*x + feedintercept;
% comparison
h = @(x) f(x) - g(x);
intercept = fzero(h,z);
bslope = (f(intercept)-xB)/(intercept-xB);
bintercept = f(intercept) - bslope*(intercept);
end

%combined line
if x <= z
    y = bslope*x + bintercept;
else
    y = tslope*x + tintercept;
end
