function [nGcell] = decay( nGcell, ndec )
%DECAY Summary of this function goes here
%   Detailed explanation goes here
dim0=nGcell{1}.dim;
parfor i=1:numel(nGcell)
    nGcell{i}.dim=dim0;
    nGcell{i}.incr_aging(ndec);
end
for i=1:numel(nGcell)
    nGcell{i}.dim=dim0;
end


end

