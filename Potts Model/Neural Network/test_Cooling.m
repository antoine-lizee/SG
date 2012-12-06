nGcool0=neuralGrid('classic',2,[100 100]);

m=[0 0 0.01 0.01 0.005 0.005];
n_cycles=[6 2 6 2 6 2];
n_trials=3;

matlabpool 3;

nGcool=cell(n_trials,numel(m));
mag=cell(n_trials,1);

for i=1:numel(m)
    disp(m(i));
    disp(n_cycles(i));
    [nGcool(:,i) mag{i}]=cooling(nGcool0,m(i),n_cycles(i),n_trials);
end
    
matlabpool close force local

for i=1:numel(m)
    figure(i); clf;
    temp=nGcool{1,i}.temphist;
    plot(-log10(temp),mag{i});
end

for i=1:numel(m)
    figure(10+i);
    clf
    en=[];
    mag=[];
    for j=1:n_trials
        en=[en,-nGcool{j,i}.enhist-m(i)*nGcool{j,i}.maghist];
        mag=[mag, nGcool{j,i}.maghist];
    end
    e{i}=en;
    mg{i}=mag;
    temp=nGcool{1,i}.temphist;
%     hold all
%     plot(e{i});
%     plot(-log10(temp));
%     plot(mg{i})
    plotyy(-log10(temp),e{i},-log10(temp),mg{i})
end

    