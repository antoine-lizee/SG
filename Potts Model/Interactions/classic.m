function funct=classic(X)

funct=arrayfun(@classicp,X);
funct=funct/0.22;
end

function funct=classicp(x)
abs=[-1 -0.1 0 0.1 0.3 1];
ord=[0 0 1 0.8 0 0];
i=find(x<abs,1)-1;
if isempty(i), i=length(abs)-1; end;
funct=ord(i)+(ord(i+1)-ord(i))/(abs(i+1)-abs(i))*(x-abs(i));
end
