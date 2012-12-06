function funct=glasses(X)

funct=arrayfun(@classicp,X);
funct=funct/2;
end

function funct=classicp(x)
abs=[-1 1];
ord=[1 1];
i=find(x<abs,1)-1;
if isempty(i), i=length(abs)-1; end;
funct=ord(i)+(ord(i+1)-ord(i))/(abs(i+1)-abs(i))*(x-abs(i));
end
