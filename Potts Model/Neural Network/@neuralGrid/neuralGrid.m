classdef neuralGrid <handle & matlab.mixin.Copyable
        
    
    properties
        dim=0; %dimension of the network
        T=1;
        B=0;
        memory=true;
    end
        
    properties (SetAccess=private)
        size=10; %array of size
        J; %Interaction Martix
        interaction; %interaction in the network
        statesType;
        nodes;
    end
       
    properties (Hidden)
        edges=false;
        storeTemp=[];
        storeB=[];
        states;
    end
    
    properties (Dependent)
        age; 
        magnetisation;
    end
    
    properties (Dependent, Hidden)
        nNodes;
        state;
    end
    
    
    
    
    methods
        
        function obj=neuralGrid(interaction_type,statesType_nG, size_nG,mem)
            %Constructor of the class 'Neural Network'
            
            %Initialization of options
            if nargin==1
                size_nG=10;
                statesType_nG=6;
            elseif nargin==2
                size_nG=10;
            end            
            if nargin<4 %By default, the network has some memory, but you can disable it when history can become huge.
                mem=true;
            end
            
            dim_nG=length(size_nG);
            if dim_nG==1
                dim_nG=0;
            elseif size_nG(2)==1 || size_nG(1)==1
                dim_nG=1; 
            end
            
            %Allocatin of properties
            obj.statesType=statesType_nG;
            obj.size=size_nG;
            obj.dim=dim_nG;
            obj.interaction=neural_interaction(interaction_type);
            obj.memory=mem;
            obj.states=[-statesType_nG/2:-1, 1:statesType_nG/2];
            
            %Definition of the interaction matrix 'J'
            %For multidimensional array, the linking between frontiers is
            %non trivial, for instance, between up and down frontiers, the
            %link is incremented. 
            %This version of neural component has a Spare matrix to enable
            %large computations
            if obj.dim==0;
                obj.J=zeros(obj.nNodes);
                ind=randi(length(obj.interaction.distrib),obj.nNodes);
                obj.J=obj.interaction.montecarlo(ind);
                obj.J(logical(eye(obj.nNodes)))=0;
            else
                obj.J=sparse(obj.nNodes,obj.nNodes);
                J_ind=sparse(obj.nNodes,obj.nNodes);
                dim_ind=[1 cumsum(obj.size)];
                for j=1:obj.dim
                    J_ind=J_ind+circshift(speye(obj.nNodes),dim_ind(j));
                end
                if obj.edges
                    prod_size=cumprod(obj.size);
                    for j=1:obj.dim
                        one_edges=sparse(zeros(1,prod_size(j)));
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
                        
            %Definition of the array 'nodes' which in this case is an array
            %of values
            if obj.dim==0                
                obj.nodes=zeros(obj.size,1,'int8');
            else
                obj.nodes=zeros(obj.size,'int8');
            end
            
            %Initialization of the network
            obj.reset;
            
        end
        function rand(obj)
            %This function randomizes the states of the nodes of the network
            newState=obj.states(randi(obj.statesType,obj.size));
            obj.nodes=cat(obj.dim+1,obj.nodes,newState);
        end
        function uni(obj)
            newState=ones(obj.size);
            obj.nodes=cat(obj.dim+1,obj.nodes,newState);
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
            if obj.dim==2
                obj.nodes=obj.nodes(:,:,end);
            elseif obj.dim==3
                obj.nodes=obj.nodes(:,:,:,end);
            end
            obj.storeTemp=[];
        end  
        function half(obj,nhalf)
            if nargin==1
                nhalf=10;
            end
            if obj.dim==3
                obj.nodes=obj.nodes(:,:,:,1:nhalf:end);
            end
        end
        function set.dim(obj,value)
            if value<0, error('la dimension ne peut pas être négative !'); end
            if value>1 && length(obj.size)~=value, error('la dimension et la taille doivent concorder'); end
            obj.dim=value;
        end
        function set.T(obj,value)
            obj.storeTemp=[obj.storeTemp [obj.T;obj.age]];
            obj.T=value;
        end
        function set.B(obj,value)
            obj.storeB=[obj.storeB [obj.B;obj.age]];
            obj.B=value;
        end
        function value=get.state(obj)
            if obj.dim==2
                value=obj.nodes(:,:,end);
            elseif obj.dim==3
                value=obj.nodes(:,:,:,end);
            end
        end
        function value=get.age(obj)
            value=size(obj.nodes,obj.dim+1);
        end
        function value=get.magnetisation(obj)
            if obj.dim==2
                value=mean(mean(obj.nodes(:,:,end),1),2);
            elseif obj.dim==3
                value=mean(mean(mean(obj.nodes(:,:,:,end),1),2),3);
            end
        end
        function value=get.nNodes(obj)
            value=prod(obj.size);
        end
       
        function m=maghist(obj)
            if obj.dim==2
                m=permute(mean(mean(obj.nodes,1),2),[3 2 1]);
            elseif obj.dim==3
                m=permute(mean(mean(mean(obj.nodes,1),2),3),[4 2 3 1]);
            end
        end
        function b=Bhist(obj)
            b=[];
            if isempty(obj.storeB)
                B=obj.B;
                a=[1 obj.age+1];
            else
                B=[obj.storeB(1,:) obj.B];
                a=[1 obj.storeB(2,:) obj.age+1];
            end
            for i=1:size(B,2)
                b=[b; B(i)*ones(a(i+1)-a(i),1)];
            end
        end
        function t=temphist(obj)
            t=[];
            if isempty(obj.storeTemp)
                T=obj.T;
                a=[1 obj.age+1];
            else
                T=[obj.storeTemp(1,:) obj.T];
                a=[1 obj.storeTemp(2,:) obj.age+1];
            end
            for i=1:size(T,2)
                t=[t; T(i)*ones(a(i+1)-a(i),1)];
            end
        end
        function energy=E(obj)
            %This funcion compute a measure of the energy of the network
            statesi=obj.state(:);
            statesj=statesi';
%             statesj=statesj*ones(1,obj.nNodes);
%             statesi=ones(obj.nNodes,1)*statesi;
%             energyMat=statesi.*statesj.*obj.J;
            energy=-(statesj*obj.J*statesi)/obj.nNodes-obj.B*obj.magnetisation;
        end
        function e=enhist(obj)
            e=zeros(obj.age,1);
            if obj.dim==2
                for k=1:obj.age
                    state=double(obj.nodes(:,:,k));
                    e(k)=-(state(:)'*obj.J*state(:))/obj.nNodes-obj.B*obj.magnetisation;
                end
            elseif obj.dim==3
                for k=1:obj.age
                    state=double(obj.nodes(:,:,:,k));
                    e(k)=-(state(:)'*obj.J*state(:))/obj.nNodes-obj.B*obj.magnetisation;
                end
            end
        end
        function h=plot(obj,age)
            if nargin==1
                age=obj.age;
            end
            if obj.dim==2
                h=image(obj.nodes(:,:,age),'CDataMapping','scaled');
            elseif obj.dim==3
                [X Y Z]=meshgrid(1:obj.size(1),1:obj.size(2),1:obj.size(3));
                c=obj.nodes(:,:,:,age);
                h=scatter3(X(:),Y(:),Z(:),10,c(:),'filled','Marker','s');
                colormap(gray);
            end
        end
        function V=video(obj)
            h=obj.nodes;
            lastdim=3;
            for k=1:size(h,lastdim);
                figure(1000);
                image(h(:,:,k),'CDataMapping','scaled');
                V(k)=getframe(1000);
            end
        end
        function movie(obj,fig,fps,age_min, age_max)
            if nargin<2
                fig=1;
            end
            if nargin<3
                fps=10;
            end
            if nargin<4
                age_min=1;
            end
            if nargin<5
                age_max=obj.age;
            end
            if obj.dim==3
                h=obj.nodes(:,:,floor(obj.size(3)/2),:);
            else
                h=obj.nodes;
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
            end
            
            lastdim=obj.dim+1;
            m=obj.maghist;
            t=obj.temphist;
            e=obj.enhist;
            x=(0:(obj.age-1))';
            
            
            figure(fig);
            clf;
            %
            axes1 = axes('Parent',fig,'YTick',zeros(1,0),'XTick',zeros(1,0),...
                'NextPlot','replacechildren',...
                'Position',[0.38 0.05 0.42 0.9],...
                'Layer','top',...
                'DataAspectRatio',[1 1 1]);
            box(axes1,'on');
            set(axes1,'DefaultImageCDataMapping','scaled');
            set(axes1,'CLim',[-1 1]);
            colormap(gray);
            title('NETWORK');
            image(obj.nodes(:,:,end));
            axis tight;
            %
            axes2 = axes('Parent',fig,'XTick',zeros(1,0),...
                'NextPlot','replacechildren',...
                'Position',[0.85 0.05 0.05 0.9]);
            ylim(axes2,[-1 1]);
            box(axes2,'on');
            title('mag');
            cmap=colormap;
            %
            axes3 = axes('Parent',fig,'YScale','log','YMinorTick','on',...
                'NextPlot','replacechildren',...
                'XTick',zeros(1,0),...
                'Position',[0.94 0.05 0.04 0.9]);
            ylim(axes3,[0.001 100]);
            box(axes3,'on');
            title('temp');
            YL=get(axes3,'YLim');
            % 
            axes4 = axes('Parent',fig,'YMinorTick','on',...
                'NextPlot','replacechildren',...
                'Position',[0.03 0.05 0.33 0.4]);
            plotyy(x,t,x,m,'semilogy','plot');
            plotyy(x,t,x,m,'semilogy','plot');
            title('magnetisation history');
            %
            axes5 = axes('Parent',fig,'YMinorTick','on',...
                'NextPlot','replacechildren',...
                'Position',[0.03 0.55 0.33 0.4]);
            plotyy(x,t,x,e,'semilogy','plot');
            plotyy(x,t,x,e,'semilogy','plot');
            title('energy history');
            %
            for k=age_min:age_max;
                image(h(:,:,k),'parent',axes1);
                title(axes1,['NETWORK AGE:' num2str(k)]);
                bar(axes2,m(k),'FaceColor',cmap(ceil((m(k)+1)/2*length(cmap)),:));
                stem(axes3,0.5,t(k),'BaseValue',YL(1),'MarkerSize',10,'Marker','s','MarkerFaceColor','r');
                drawnow;
                pause(1/fps);
            end
        end
            
    end

end




