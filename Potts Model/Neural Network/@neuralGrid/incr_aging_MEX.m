function incr_aging_MEX( obj, n) %#codegen
%INCR_AGING makes the network "age", each node of the network evolving
%randomly according to the temperature of the network and the interaction
%matrix J. The optional argument is the number of increment. For an example
%of such a network evolution you can launch the script "ex_temp"

%This version is for the high efficiency version of the neural Network, the
%neuralGrid.

%the full version, inc_raging_2, gives 40s
%the pre-otimized version gives 4s (!!)
%the fully optimized MEX based version takes 2.8s


if nargin<2
    n=1;
end

n=uint32(n);

m=obj.B;
State=obj.state;
[i, j, v]=find(obj.J);
kneigh=obj.dim*2;
if obj.edges
    J=zeros([obj.dim*2 obj.nNodes]);
    Ind=ones([obj.dim*2 obj.nNodes]);
    index=1:length(v);
    disp('launching the highly non optimized algorithm to transform obj.J into J and Ind in the case of NeuralGrid with edges.');
    disp('You can press Ctrl+C to stop it. It takes up to fuve minutes for a [50 50 50] grid and is quadratic');
    tic
    for k=1:obj.nNodes
        offset=kneigh-nnz(j==k); % These two lines are absolutely non optimized. It will be much quicker to derive all these values at once, instead of looking up in the huge vector for each value.
        indexj=find(j==k,1);
        if offset~=0
            index(indexj:end)=index(indexj:end)+offset;
        end
    end
    t=toc;
    disp(['transformation completed in ' num2str(t/60) 'minutes']);
    J(index)=v(:);
    Ind(index)=i(:);
    Ind=Ind';
else
    J=reshape(v,[obj.dim*2 obj.nNodes]);%WATCH OUT ! This line implies that the property edges is set to false in the constructor of the neuralGrid
    Ind=uint32(reshape(i,[obj.dim*2 obj.nNodes]))';
end
Dim=uint8(obj.dim);
Size=uint16(obj.size);
T=obj.T;
nNodes=uint16(obj.nNodes);

nodes2=incr_aging_lowlevel_mex(State,J,Ind,m,n,Dim,Size,nNodes,T);
obj.nodes=cat(obj.dim+1,obj.nodes,nodes2);

end

