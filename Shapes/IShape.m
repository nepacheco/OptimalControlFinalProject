classdef IShape < Shape
    %LShape Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = IShape(loc)
            obj.structures = {[zeros(1,4); ones(1,4); zeros(2,4)],
                              [zeros(4,2), ones(4,1), zeros(4,1)],
                              [zeros(2,4); ones(1,4); zeros(1,4)],
                              [zeros(4,1), ones(4,1), zeros(4,2)]};
            
            obj.structure = obj.structures{1};
            obj.loc = loc;
            obj.orientation = 0;
            obj.id = 0;
        end
    end
end

