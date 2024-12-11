classdef TShape < Shape
    %LShape Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = TShape(loc)
            obj.structures = {[0 1 0 0; 1 1 1 0; 0 0 0 0; 0 0 0 0],
                              [0 1 0 0; 0 1 1 0; 0 1 0 0; 0 0 0 0],
                              [0 0 0 0; 1 1 1 0; 0 1 0 0; 0 0 0 0],
                              [0 1 0 0; 1 1 0 0; 0 1 0 0; 0 0 0 0]};
            
            obj.structure = obj.structures{1};
            obj.loc = loc;
            obj.orientation = 0;
            obj.id = 5;
        end
    end
end

