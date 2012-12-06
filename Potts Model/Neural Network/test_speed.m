function b=test_speed(version)
% The profiler on this test function shows that there is arel difference
% between processing speed of a simple calculus.
% 'lin' 9s
% 'elt' 39s
% 'sp' 0.058s
% 'spelt' 14.5s
imax=10^4;
indmax=10^6;
a=1:indmax;
J=zeros(indmax,1);
ind=randi(indmax,100,1);
J(ind)=rand(100,1);
Js=sparse(J);

b=zeros(imax,1);

switch version
    case 'lin'
        for i=1:imax
            b(i)=a*J;
        end
    case 'elt'
        a=a';
        for i=1:imax
            b(i)=sum(a.*J);
        end
    case 'sp'
        for i=1:imax
            b(i)=a*Js;
        end
    case 'spelt'
        a=a';
        for i=1:imax
            b(i)=sum(a.*Js);
        end
end