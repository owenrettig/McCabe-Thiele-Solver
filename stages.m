function [xstage,ystage,feed_stage,num_stages,finalcomp] = stages(z,xB,xD,L,V,p,q,feedslope,feedintercept)

xstage(1) = xD;
ystage(1) = xD;

f = @(p,x) p(1) + p(2)*x.^4 + p(3)./(x + 10^-2) + p(4).*sqrt(x) + p(5).*(x).^(1/3) + p(6).*x + p(7).*(x).^(1/10);

i = 2;
feed_stage = 0;
num_stages = 0;
finalcomp = 0;

while true
    g = @(x) f(p,x) - ystage(i-1);
    xstage(i) = fzero(g,xstage(i-1));
    % xstage(i) = fzero(g,0.5);
    ystage(i) = f(p,xstage(i));
    xstage(i+1) = xstage(i);
    ystage(i+1) =operating_line_calc(xstage(i+1),L,V,xB,xD,z,q,feedslope,feedintercept);
    if z > xstage(i) && z > ystage(i) && feed_stage == 0
        feed_stage = (i-4)/2;
    end
    if ystage(i+1) < xB
        num_stages = (i)/2;
        finalcomp = operating_line_calc(xstage(i+1),L,V,xB,xD,z,q,feedslope,feedintercept);
        break
    end
    if i > 20
        break
    end

    i = i + 2;
end