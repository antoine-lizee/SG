function [nodes2]=incr_aging_lowlevel( State,J,Ind,m,n,Dim,Size,nNodes,T) %#codegen
%INCR_AGING makes the network "age", each node of the network evolving
%randomly according to the temperature of the network and the interaction
%matrix J. The optional argument is the number of increment. For an example
%of such a network evolution you can launch the script "ex_temp"

%This version is for the high efficiency version of the neural Network, the
%neuralGrid.

newState=double(State);
coder.varsize('newState',size(State));
nodes2=int8(zeros([size(State), n]));
aStates=newState(:)';
%             
% switch Dim
%     case 2
%         for i=1:n   
%             index=randperm(nNodes);
%             for j=1:nNodes
%                 k=index(j);
%                 bias=aStates(Ind(k,:))*J(:,k)+2*m;
%                 DE=bias*aStates(k)/T;
%                 p=1./(1+exp(-2*DE));
%                 d=rand;
%                 if p<d
%                     aStates(k)=-aStates(k);
%                 end
%             end
%             newState=reshape(aStates,Size);
%             nodes2(:,:,i)=int8(newState);
%         end
%     case 3
        for i=1:n   
            index=randperm(nNodes);
            for j=1:nNodes
                k=index(j);
                bias=aStates(Ind(k,:))*J(:,k)+2*m;
                DE=bias*aStates(k)/T;
                p=1./(1+exp(-2*DE));
                d=rand;
                if p<d
                    aStates(k)=-aStates(k);
                end
            end
            newState=reshape(aStates,Size);
            nodes2(:,:,:,i)=int8(newState);
        end
% end

end

