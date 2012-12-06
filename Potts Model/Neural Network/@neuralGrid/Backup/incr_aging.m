function incr_aging( obj, n)
%INCR_AGING makes the network "age", each node of the network evolving
%randomly according to the temperature of the network and the interaction
%matrix J. The optional argument is the number of increment. For an example
%of such a network evolution you can launch the script "ex_temp"

%This version is for the high efficiency version of the neural Network, the
%neuralGrid.

simultaneity=0;
parallelprocessing=0;
n_cores=4;

if nargin<2
    n=1;
end

m=obj.B;
newState=double(obj.state);

for i=1:n
    if simultaneity
        aStates=newState(:)';
        bias=aStates*obj.J+m;
        DE=bias.*aStates/obj.T;
        p=exp(2*DE)./(1+exp(2*DE));
        p(isnan(p))=1;
        d=rand(size(bias));
        index=(p<d);
        newStates(index)=-newStates(index);        
        
    elseif parallelprocessing 
        nNd=obj.nNodes;
        r=mod(nNd,n_cores);
        n=floor(nNd/n_cores);
        index=randperm(nNd);
        indexp=reshape(index(1:end-r),n,n_cores);
        indexend=index(end-r+1:end);
        aStates=newState(:)';
        for j=1:n
            bool_pf=false(n_cores,1);
            ind_pf=indexp(j,:);
            parfor l=1:n_cores
                k=ind_pf(l);
                bias=aStates*obj.J(:,k)+m;
                DE=bias*aStates(k)/obj.T;
                p=exp(2*DE)./(1+exp(2*DE));
                p(isnan(p))=1;
                d=rand;
                if p<d
                   bool_pf(l)=true;
                end
            end
            aStates(ind_pf(bool_pf))=-aStates(ind_pf(bool_pf));
        end
        for j=1:r
            k=indexend(j);
            bias=aStates*obj.J(:,k)+m;
            DE=bias*aStates(k)/obj.T;
            p=exp(2*DE)./(1+exp(2*DE));
            p(isnan(p))=1;
            d=rand;
            if p<d
                aStates(k)=-aStates(k);
            end
        end
        newState=reshape(aStates,obj.size);        
    
    else
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
    end
    obj.nodes=cat(obj.dim+1,obj.nodes,newState);
    
end


end

