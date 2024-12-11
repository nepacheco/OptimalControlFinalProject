classdef (Abstract) Shape
    properties
        structure (4,4) double
        structures (1,4) cell
        loc (1,2) double = [1,4]% Corresponds to top left of structure in grid
        orientation (1,1) double {mustBeInRange(orientation,0,3)}
        id
    end
    
    methods (Abstract)
    end
    
    methods
        function isValid = valid_shape(obj)
            isValid = true;
        end
        
        function obj = rotate(obj,u)
            obj.orientation = mod(obj.orientation + u,4);
            
            obj.structure = obj.structures{obj.orientation+1};
            
        end
        
        function obj = move(obj,u)
            obj.loc = [obj.loc(1), obj.loc(2) + u];
        end
        
        function obj = gravity(obj)
            obj.loc = [obj.loc(1)+1, obj.loc(2)];
        end
    end
    
end