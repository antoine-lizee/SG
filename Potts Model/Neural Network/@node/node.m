classdef node < handle
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        actualState;
        memory=true;
    end
       
    properties (SetAccess=private)
        states;
        statesType;        
        previousStates;
    end
    
    methods
        function obj=node(statesType_n, actualState_n, mem)
            if nargin>0
                if nargin==1
                    actualState_n=1;
                elseif nargin==3
                    obj.memory=mem;
                end
                obj.statesType=statesType_n;
                obj.states=-statesType_n+1:2:statesType_n;            
                obj.actualState=actualState_n;
            end
        end
        function set.actualState(obj,value)
            if ~any(value==obj.states)
                error('NODE:wrongstate',['impossible to set the state %g since this node only have the following possible states : ' num2str(obj.states)],value);
            end
            if obj.memory
                obj.previousStates=[obj.previousStates obj.actualState];
            end
            obj.actualState=value;
        end
        function reset(obj)
            obj.previousStates=[];
        end
        function flip(obj)
           obj.actualState=-obj.actualState;
        end
        function stay(obj)
            obj.actualState=obj.actualState;
        end
    end
end

