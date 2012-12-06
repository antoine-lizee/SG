%nGstep0=neuralGrid('classic',2,[300 300]);
n_trials=3;

%n_cycles=40;
%T=repmat([0.5 0.05],1,6);
%B=[0.001 0.002];
nGstep=cell(n_trials,numel(B));
%disp(nGcool0)

for i=1:n_trials;
    nGstep(i,1)={neuralGrid('classic',2,[400 400])};
    for j=2:numel(B)
        nGstep(i,j)={copy(nGstep{i,1})};
    end
end
matlabpool 3
disp('initialisation finished');
tic
for l=1:numel(B)
    disp(['Computing for B=' num2str(B(l)) '...']);
    parfor i=1:n_trials;
        %disp(nGcool0)
        %nGstep(i)={copy(nGcool0)};
        nGstep{i,l}.B=B(l);
        for j=1:numel(T)
            %disp(T(j));
            nGstep{i,l}.T=T(j);
            nGstep{i,l}.incr_aging(n_cycles);
        end
    end
    t=toc;
    disp(['...completed after ' num2str(t/60) ' minutes']);
end

for k=1:numel(nGstep) % uncomment the other lines to see : %if I don't do that, dim (and not T, for instance) take the default value of [], BUT only with parfor !!!! Bug??!!
    nGstep{k}.dim=2;
end
matlabpool close force local

%save('step_0.5_0.05_6_40','nGstep');