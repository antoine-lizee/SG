
matlabpool 4
n_cyclesmc=300;
n_mc=50;
T=[0.1 1 1.5 2 2.1 2.2 2.23 2.25 2.26 2.265 2.268 2.269 2.27 2.275 2.3 2.5 3];
mag=zeros(n_mc,length(T));

parfor i=1:length(T);
    nGcurie=neuralGrid('Ising',2,[50 50]);
    disp(T(i));
    nGcurie.T=T(i);
    for j=1:n_mc
        nGcurie.reset('cold');
        nGcurie.incr_aging(n_cyclesmc);
        m=nGcurie.maghist;
        mag(j,i)=mean(m(end-3,end));
    end
    nGcurie=[];
end

matlabpool close force local

magm=mean(mag,1);
figure(2);
title('representation of Curie temperature');
plot(T,magm,'-*',T, zeros(1,length(T)));