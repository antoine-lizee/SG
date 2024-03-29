classdef neuralNetwork <handle
        
    
    properties
        dim=0; %dimension of the network
        T=1;
        memory=true;
    end
        
    properties (SetAccess=private)
        age=0; 
        size=10; %array of size
        J; %Interaction Martix
        interaction; %interaction in the network
        statesType;
        nodes=node(6,1);
    end
       
    properties (Hidden)
        edges=true;
        storeTemp=[];
    end
    
    properties (Dependent)
        magnetisation;
    end
    
    properties (Dependent, Hidden)
        nNodes;
    end
    
    
    
    
    methods
        
        function obj=neuralNetwork(interaction_type,statesType_nN, size_nN,dim_nN,mem)
            %Constructor of the class 'Neural Network'
            
            %Initialization of options
            if nargin==1
                size_nN=10;
                dim_nN=0;
                statesType_nN=6;
            elseif nargin==2
                size_nN=10;
                dim_nN=0;
            elseif nargin==3
                dim_nN=length(size_nN);
                if dim_nN==1, dim_nN=0;
                elseif size_nN(2)==1 || size_nN(1)==1, dim_nN=1; end
            end            
            if nargin<5 %By default, the network has some memory, but you can disable it when history can become huge.
                mem=true;
            end
            
            %Allocatin of properties
            obj.statesType=statesType_nN;
            obj.size=size_nN;
            obj.dim=dim_nN;
            obj.interaction=neural_interaction(interaction_type);
            obj.memory=mem;            
            
            %Definition of the interaction matrix 'J'
            %For multidimensional array, the linking between frontiers is
            %non trivial, for instance, between up and down frontiers, the
            %link is incremented. Lanch the twofollowing lines as an
            %example:
            %nN1=neuralNetwork('Ising',2,[20 4]);
            %reshape(nN1.J(:,21),nN1.size);
            if obj.dim==0;
                obj.J(logical(eye(length(obj.J))))=0;
            else
                J_ind=zeros(obj.nNodes);
                dim_ind=[1 cumsum(obj.size)];
                for j=1:obj.dim
                    J_ind=J_ind+circshift(eye(obj.nNodes),dim_ind(j));
                end
                if obj.edges
                    prod_size=cumprod(obj.size);
                    for j=1:obj.dim
                        one_edges=zeros(1,prod_size(j));
                        one_edges(prod_size(j)-dim_ind(j)+1:prod_size(j))=1;
                        one_edges=repmat(one_edges,1,obj.nNodes/prod_size(j));
                        one_edges=logical(one_edges);
                        ind_edges=diag(one_edges);
                        J_ind(circshift(ind_edges,dim_ind(j)))=0;
                    end
                end
                J_ind=J_ind+J_ind';
                ind=randi(length(obj.interaction.distrib),nnz(J_ind),1);
                obj.J(logical(J_ind))=obj.interaction.montecarlo(ind);
            end
            disp(num2str(nnz(obj.J)/numel(obj.J),'density of J is equal to %g'));
            obj.J=sparse(obj.J);
                        
            %Definition of the node array 'nodes'
            if obj.dim==0                
                obj.nodes(obj.size)=node();
            else
                obj.nodes(ones(obj.size))=node();
            end
            for k=1:obj.nNodes
                obj.nodes(k)=node(obj.statesType,1,obj.memory);
            end
            
            %Initialization of the network
            obj.reset;
            
        end
        function rand(obj)
            %This function randomizes the states of the nodes of the network
            for i=1:obj.nNodes
                n=obj.nodes(i);
                n.actualState=n.states(randi(length(n.states)));
            end
            obj.age=obj.age+1;
        end
        function uni(obj)
            for i=1:obj.nNodes
                obj.nodes(i).actualState=1;
            end
            obj.age=obj.age+1;
        end
        function reset(obj,temp)
            %This function clear the memory of the network and set
            %the states of the nodes of the network
            if nargin==1
                temp='warm';
            end
                
            switch temp
                case 'warm'
                    obj.rand
                case 'cold'
                    obj.uni
            end
            
            for k=1:obj.nNodes
                obj.nodes(k).reset;
            end
            obj.age=0;
            obj.storeTemp=[];
        end  
        function set.dim(obj,value)
            if value<0, error('la dimension ne peut pas �tre n�gative !'); end
            if value>1 && length(obj.size)~=value, error('la dimension et la taille doivent concorder'); end
        obj.dim=value;
        end
        function set.memory(obj,value)
            for k=1:obj.nNodes
                obj.nodes(k).memory=value;
            end
            obj.memory=value;
        end
        function set.T(obj,value)
            obj.storeTemp=[obj.storeTemp [obj.T;obj.age]];
            obj.T=value;
        end
        function value=get.magnetisation(obj)
            value=mean(mean(obj.state,1),2);
        end
        function value=get.nNodes(obj)
            value=prod(obj.size);
        end
       
        function m=maghist(obj)
            m=permute(mean(mean(obj.history,1),2),[3 2 1]);
        end
        function t=temphist(obj)
            t=[];
            if isempty(obj.storeTemp)
                T=obj.T;
                a=[0 obj.age+1];
            else
                T=[obj.storeTemp(1,:) obj.T];
                a=[0 obj.storeTemp(2,:) obj.age+1];
            end
            for i=1:size(T,2)
                t=[t T(i)*ones(1,a(i+1)-a(i))];
            end
        end
        function energy=E(obj)
            %This funcion compute a measure of the energy of the network
            statesi=[obj.nodes(:).actualState];
            statesj=statesi';
            statesj=statesj*ones(1,obj.nNodes);
            statesi=ones(obj.nNodes,1)*statesi;
            energyMat=statesi.*statesj.*obj.J;
            energy=sum(energyMat(:));
        end
        function s=state(obj)
            %This function get the states of all the nodes of the netork
            s=cat(2,obj.nodes(:).actualState);
            if obj.dim~=0;
                s=reshape(s,obj.size);
            end
        end
        function h=history(obj)
            %this function get the history of the Network, i.e. all the
            %states stored in its memory
            if obj.memory==false;
                disp('Impossible to get history of a network without memory')
                return
            end
            h=cat(1,obj.nodes(:).previousStates);
            h=permute(h,[3 1 2]);
            if obj.dim~=0;
                h=reshape(h,[obj.size size(h,3)]);
            end
            h=cat(3,h, obj.state);
        end 
        function h=plot(obj)
            h=image(obj.state,'CDataMapping','scaled');
        end
        function V=video(obj)
            h=obj.history;
            lastdim=3;
            for k=1:size(h,lastdim);
                figure(1000);
                image(h(:,:,k),'CDataMapping','scaled');
                V(k)=getframe(1000);
            end
        end
        function movie(obj,fig,fps)
            if nargin<2
                fig=1;
            end
            if nargin<3
                fps=10;
            end
            h=obj.history;
            if obj.dim==1 || obj.dim==0
                d=floor(sqrt(size(h,2)));
                c=ceil(size(h,2)/d);
                h=[h zeros(1,c*d-size(h,2),size(h,3))];
                if obj.dim==1
                    h(2,:,:)=0;
                    h=reshape(h,2*c,d,size(h,3));
                else
                    h=reshape(h,c,size(h,2)/c,size(h,3));
                end
            end
            lastdim=3;
            m=obj.maghist;
            t=obj.temphist;
            
            
            figure(fig);
            clf;
            %
            axes1 = axes('Parent',fig,'YTick',zeros(1,0),'XTick',zeros(1,0),...
                'NextPlot','replacechildren',...
                'Position',[0.03 0.05 0.7 0.9],...
                'Layer','top',...
                'DataAspectRatio',[1 1 1]);
            box(axes1,'on');
            set(axes1,'DefaultImageCDataMapping','scaled');
            title('NETWORK');
            image(obj.state);
            axis tight;
            %
            axes2 = axes('Parent',fig,'XTick',zeros(1,0),...
                'NextPlot','replacechildren',...
                'Position',[0.78 0.05 0.1 0.9]);
            ylim(axes2,[-1 1]);
            box(axes2,'on');
            title('magnetisation');
            cmap=colormap;
            %
            axes3 = axes('Parent',fig,'YScale','log','YMinorTick','on',...
                'NextPlot','replacechildren',...
                'XTick',zeros(1,0),...
                'Position',[0.92 0.05 0.05 0.9]);
            ylim(axes3,[0.001 100]);
            box(axes3,'on');
            title('temperature');
            YL=get(axes3,'YLim');
            %
            for k=1:size(h,lastdim);
                image(h(:,:,k),'parent',axes1);
                bar(axes2,m(k),'FaceColor',cmap(ceil((obj.magnetisation+1)/2*length(cmap)),:));
                stem(axes3,0.5,t(k),'BaseValue',YL(1),'MarkerSize',10,'Marker','s','MarkerFaceColor','r');
                drawnow;
                pause(1/fps);
            end
        end
            
    end

end




