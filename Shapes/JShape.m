classdef JShape < Shape
    %LShape Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = JShape(loc)
            obj.structures = {[1 0 0 0; 1 1 1 0; zeros(2,4)],
                              [0 1 1 0; 0 1 0 0; 0 1 0 0; 0 0 0 0],
                              [0 0 0 0; 1 1 1 0; 0 0 1 0; 0 0 0 0],
                              [0 1 0 0; 0 1 0 0; 1 1 0 0; 0 0 0 0]};
            
            obj.structure = obj.structures{1};
            obj.loc = loc;
            obj.orientation = 0;
            obj.id = 1;
        end
        
    end
end

