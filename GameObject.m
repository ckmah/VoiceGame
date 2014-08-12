classdef GameObject
  properties (SetAccess = public, GetAccess = public)
    x % x position
    y % y position
    radius % determines size for overlap
    visible % boolean whether exists or not
  end
  methods
    % -------------------- CONSTRUCTOR --------------------
    function obj = GameObject(x, y, r, v)
      if nargin > 0
        obj.x = x;
        obj.y = y;
        obj.radius = v;
        obj.visible = true;
      end
    end
    % -------------------- ACCESS METHODS --------------------
    % get obj x position
    function value = get.x(obj)
      value = obj.x;
    end
    % get obj y position
    function value = get.y(obj)
      value = obj.y;
    end
    % get obj radius
    function value = get.radius(obj)
      value = obj.radius;
    end
    % get obj visibility
    function value = get.visible(obj)
      value = obj.visible;
    end

    % -------------------- SET METHODS --------------------
    % set obj x position
    function obj = set.x(obj,xPos)
      obj.x = xPos;
    end
    % set obj y position
    function obj = set.y(obj,yPos)
      obj.y = yPos;
    end
    % set obj radius
    function obj = set.radius(obj,rad)
      obj.radius = rad;
    end
    % set obj visibility
    function obj = set.visible(obj,vis)
      obj.visible = vis;
    end

    % -------------------- FUNCTIONAL METHODS --------------------
 end
end
