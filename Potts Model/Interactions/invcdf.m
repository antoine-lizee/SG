function [distrib Y]=invcdf(X,cdf, step)
%This function create the inverse of the cumulative density function for a
%variable X whose cdf is specified in argument.
%'distrib' is the vector describing the cumulative probability
%'Y' is the value of the variable.
%'step' is the input argument which describes the precision of the cutting
%of the cumulative probability. This is useless to take a step smaller than
%the step of the varaible description (in normalized unit along the span of
%the variable)

distrib=0:step:1;
Y=arrayfun(@invcdfp,distrib);

function y=invcdfp(x)
abs=cdf;
ord=X;
i=find(x<abs,1)-1;
if isempty(i), i=length(abs)-1; end;
y=ord(i)+(ord(i+1)-ord(i))/(abs(i+1)-abs(i))*(x-abs(i));
end

end
