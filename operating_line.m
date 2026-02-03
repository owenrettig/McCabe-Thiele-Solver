function [xop,yop] = operating_line(xcalc,L,V,xB,xD,z,q,feedslope,feedintercept)

intercept = z;

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
for i = 1:length(xcalc)
    if xcalc(i) <= intercept
        %need to incorporate feed line
        xop(i) = xcalc(i);
        yop(i) = bslope*xop(i) + bintercept;
    else
        xop(i) = xcalc(i);
        yop(i) = tslope*xop(i) + tintercept;
    end
end

