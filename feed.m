function [xfeed,yfeed,feedslope,feedintercept] = feed(xcalc,q,z)

feedslope = 0;
feedintercept =0;

if q == 1
    xfeed(1) = z;
    xfeed(2) = z;
    yfeed(1) = 0;
    yfeed(2) = 1;
elseif q == 0
    xfeed(1) = 0;
    xfeed(2) = 1;
    yfeed(1) = z;
    yfeed(2) = z;
else
    slope = q/(q-1);
    intercept = (1/(1-q))*z;
    xfeed = xcalc;
    yfeed = xcalc.*slope + intercept;
    feedslope = slope;
    feedintercept = intercept;
end
    
