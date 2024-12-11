classdef EmptyShape < Shape
    %LShape Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = EmptyShape(loc)
            obj.structures = {zeros(4,4), zeros(4,4),zeros(4,4),zeros(4,4)};
            
            obj.structure = obj.structures{1};
            obj.loc = loc;
            obj.orientation = 0;
            obj.id = 0;
        end

        function isValid = valid_shape(obj)
            isValid = false;
        end
    end
end

