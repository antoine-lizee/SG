function incr_aging_2( obj, n) %#codegen
%INCR_AGING makes the network "age", each node of the network evolving
%randomly according to the temperature of the network and the interaction
%matrix J. The optional argument is the number of increment. For an example
%of such a network evolution you can launch the script "ex_temp"

%This version is for the high efficiency version of the neural Network, the
%neuralGrid.


if nargin<2
    n=1;
end

m=obj.B;
newState=double(obj.state);

for i=1:n   
    index=randperm(obj.nNodes);
    aStates=newState(:)';
    for j=1:obj.nNodes
        k=index(j);
        bias=aStates*obj.J(:,k)+2*m;
        DE=bias*aStates(k)/obj.T;
        p=1./(1+exp(-2*DE));
        d=rand;
        if p<d
            aStates(k)=-aStates(k);
        end
    end
    newState=reshape(aStates,obj.size);
    obj.nodes=cat(obj.dim+1,obj.nodes,int8(newState));
end


end

