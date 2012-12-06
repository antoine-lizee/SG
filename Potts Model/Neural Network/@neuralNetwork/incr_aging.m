function incr_aging( obj, n)
%INCR_AGING makes the network "age", each node of the network evolving
%randomly according to the temperature of the network and the interaction
%matrix J. The optional argument is the number of increment. For an example
%of such a network evolution you can launch the script "ex_temp"

simultaneity=0;
parallelprocessing=0;
n_cores=4;

if nargin<2
    n=1;
end

m=obj.B;

for i=1:n
    if simultaneity
        aStates=[obj.nodes(:).actualState];
        bias=aStates*obj.J+m;
        DE=bias.*aStates/obj.T;
        p=exp(2*DE)./(1+exp(2*DE));
        p(isnan(p))=1;
        d=rand(size(bias));
        index=(p<d);
        for j=1:length(index)
            if index(j)
                obj.nodes(j).flip;
            else
                obj.nodes(j).stay;
            end
        end
        
    elseif parallelprocessing
        nNd=obj.nNodes;
        r=mod(nNd,n_cores);
        n=floor(nNd/n_cores);
        index=randperm(nNd);
        indexp=reshape(index(1:end-r),n,n_cores);
        indexend=index(end-r+1:end);
        aStates=[obj.nodes(:).actualState];
        for j=1:n
            parfor l=1:n_cores
                k=indexp(j,l);
                nd=obj.nodes(k);
                bias=aStates*obj.J(:,k)+m;
                DE=bias*nd.actualState/obj.T;
                p=exp(2*DE)./(1+exp(2*DE));
                p(isnan(p))=1;
                d=rand;
                if p<d
                    nd.flip;
                else
                    nd.stay;
                end
                a(l)=nd.actualState;
            end
            aStates(indexp(j,:))=a;
        end
        for j=1:r
            k=indexend(j);
            nd=obj.nodes(k);
            bias=aStates*obj.J(:,k)+m;
            DE=bias*nd.actualState/obj.T;
            p=exp(2*DE)./(1+exp(2*DE));
            p(isnan(p))=1;
            d=rand;
            if p<d
                nd.flip;
            else
                nd.stay;
            end
            aStates(k)=nd.actualState;
        end        
    
    else
        index=randperm(obj.nNodes);
        aStates=[obj.nodes(:).actualState];
        for j=1:obj.nNodes
            k=index(j);
            nd=obj.nodes(k);
            bias=aStates*obj.J(:,k)+m;
            DE=bias*nd.actualState/obj.T;
            p=exp(2*DE)./(1+exp(2*DE));
            p(isnan(p))=1;
            d=rand;
            if p<d
                nd.flip;
            else
                nd.stay;
            end
            aStates(k)=nd.actualState;
        end
    end        
end

obj.age=obj.age+n;

end

