clc
clear

%import data from excel
% Read all numeric data from a specific sheet
filename = 'VLE Data.xlsx';
sheetname = 'VLE'; % change to your sheet name

nums = readmatrix(filename, 'Sheet', sheetname);
xcalc = linspace(0.0001,1,1000);
x = nums(:,1);
x(1) = 10^-10;
y = nums(:,2);
L = nums(1,4);
B = nums(2,4);
F = nums(3,4);
Vbar = nums(4,4);
Lbar = nums(5,4);
xB = nums(6,4);
xD = nums(7,4);
z = nums(8,4);
q = nums(9,4);
V = nums(10,4);





%perform regression
p0 = [0.1, 0, 0.1, 0.1, 0.2, 0, 0];
% f = @(p,x) p(1) + p(2)*x.^4 + p(3)./x + p(4).*sqrt(x + 10^-9) + p(5).*(x + 10^-9).^(1/3) + p(6).*x + p(7).*(x + 10^9).^(1/10);
f = @(p,x) p(1) + p(2)*x.^4 + p(3)./(x + 10^-2) + p(4).*sqrt(x) + p(5).*(x).^(1/3) + p(6).*x + p(7).*(x).^(1/10);

p = lsqcurvefit(f, p0, x, y);

%feed line equation
[xfeed,yfeed,feedslope,feedintercept] = feed(xcalc,q,z);

% operating line equation
[xop,yop] = operating_line(xcalc,L,V,xB,xD,z,q,feedslope,feedintercept);

%stages 
[xstage,ystage,feed_stage,num_stages,finalcomp] = stages(z,xB,xD,L,V,p,q,feedslope,feedintercept);

% y = x line
xlin = [0,1];
ylin = [0,1];

%plot results
ycalc = f(p,xcalc);
plot(xcalc,ycalc,xfeed,yfeed,xlin,ylin,xop,yop,xstage,ystage,x,y,"wo");
xlabel("x1")
ylabel("y1")
xlim([0,1]);
ylim([0,1]);
legend('Regressed Fit','Feed Line','y = x','Operating Line','Stages','Experimental Data','location','best')

fprintf("%i stages were required, feed stage is %i. The bottoms composition " + ...
    "is %g, and the distillate composition is %g", ...
    num_stages,feed_stage, finalcomp,xD);



