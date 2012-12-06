T=[5 5.5 5.7];
M=[];
kmax=3;
hold on
for k=1:kmax
for i=1:length(T)
    nNtemp(i)=neuralNetwork('Ising',2,[30 30]);
    nNtemp(i).T=T(i);
    nNtemp(i).incr_aging(1000);
    M(:,i,k)=nNtemp(i).maghist;
end
nNtot{k}=nNtemp;
%figure(1);
%plot(M(:,:,k));
end

for i=1:length(T)
    figure(i)
    plot(permute(M(:,i,:),[1 3 2]))
end

%%Conclusions
%for a synchronise incremental aging, we have three phases, and the
%pseudo-equilibrium state can have a different total magnetisation from 1
%or -1. typical results are stored in 'nNtempsync2000.mat'