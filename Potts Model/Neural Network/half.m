function [ nGcell ] = half( nGcell, n )
%HALF_CELL Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    n=10;
end

%nGcell2=nGcell;

for i=1:numel(nGcell)
    nGcell{i}.half(n);
end

end

