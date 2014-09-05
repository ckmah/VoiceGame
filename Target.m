%
% Extends GameObject. Target object that player aims to collect/collide. Further implementation TBD.
%
classdef Target < GameObject
  methods
    function obj = Target(x,y,r,v)
      args = {};
      if nargin == 0 % no input args
        args = {};
      else
        args = {x,y,r,v};
      end
      obj = obj@GameObject(args{:});
    end
  end
end
