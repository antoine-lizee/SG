function nGcool=cooling(nGcool0,n_cycles,n_trials,lnT)

nGcool=cell(n_trials,1);
if nargin<4
    lnT=0.3:0.01:2.2;
end
T=(10*ones(1,numel(lnT))).^-lnT;

dim0=nGcool0.dim;    
%disp(nGcool0)
parfor i=1:n_trials;
    %disp(nGcool0)
    nGcool(i)={copy(nGcool0)};
    nGcool{i}.dim=dim0; % uncomment the other lines to see : %if I don't do that, dim (and not T, for instance) take the default value of [], BUT only with parfor !!!! Bug??!!
    for j=1:numel(lnT)
        disp(T(j));
        nGcool{i}.T=T(j);
        nGcool{i}.incr_aging(n_cycles);
    end
end
%disp(nGcool0)
for k=1:numel(nGcool)     
    nGcool{k}.dim=nGcool0.dim; % uncomment the other lines to see : %if I don't do that, dim (and not T, for instance) take the default value of [], BUT only with parfor !!!! Bug??!!
end
    
end