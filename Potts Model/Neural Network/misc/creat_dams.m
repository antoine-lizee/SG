nNtest=neuralNetwork('Ising',2,[20 20]);

% damier_vector1=zeros(nNtest.size(1),1);
% damier_vector1(1:2:end)=1;
% damier_vector2=zeros(1,nNtest.size(2));
% damier_vector2(1:2:end)=1;
% damier=bsxfun(@times,damier_vector1,damier_vector2);
% damier=tril(damier);

d=zeros(nNtest.size);
for k=1:2:nNtest.size(1)
    d=d+diag(ones(nNtest.size(1)-k,1),k);
end

for k=1:nNtest.nNodes
    if d(k)
        nNtest.nodes(k).actualState=1;
    else
        nNtest.nodes(k).actualState=-1;
    end
end
        
