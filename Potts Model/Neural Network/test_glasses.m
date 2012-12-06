
nNglass=neuralNetwork('classic',2,[50 50]);
n_cycles=3;
T=[0.1 0.003];
l_cycle=[100,20];
ages=nNglass.age;
for i=1:n_cycles
    for j=1:length(T)
        nNglass.T=T(j);
        nNglass.incr_aging(l_cycle(j));
        ages=[ages ages(end)+l_cycle(j)];
    end
%     nNglass.T=1;
%     nNglass.incr_aging(l_cycle);
%     nNglass.T=0.03;
%     nNglass.incr_aging(5*l_cycle);
%     nNglass.T=0.1;
%     nNglass.incr_aging(l_cycle);
%     nNglass.T=0.03;
%     nNglass.incr_aging(l_cycle);
%     nNglass.T=0.01;
%     nNglass.incr_aging(l_cycle);
%     nNglass.T=0.003;
%     nNglass.incr_aging(l_cycle);
end
figure(2);
clf;
l=length(nNglass.maghist);
hold all;
plot(nNglass.maghist);
plot([0,l],[0 0],':g');
plot([1;1]*ages(1,2:end),[1; -1]*ones(1,n_cycles*length(l_cycle)));
