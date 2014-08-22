%
% Extends GameObject. Target object that player aims to collect/collide. Further implementation TBD.
%
classdef Target < GameObject
  methods
    function obj = Target(x,y,r,v)
      obj@GameObject(x,y,r,v);
    end
  end
end
