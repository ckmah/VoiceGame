classdef Player < GameObject
  properties (SetAccess = public, GetAccess = public)
    points % equivalent to number of hit targets
    missed % equivalent to number of missed targets
  end
  methods
    % -------------------- CONSTRUCTOR --------------------
    function obj = Player(x,y,r,v)
      obj@GameObject(x,y,r,v);
      if nargin > 0
        obj.points = 0;
        obj.missed = 0;
      end
    end

    % -------------------- ACCESS METHODS --------------------
    % get obj points position
    function value = get.points(obj)
      value = obj.points;
    end
    % get obj points position
    function value = get.missed(obj)
      value = obj.missed;
    end
    % function (obj)
    %   disp@MySuperClass(obj)

    % -------------------- SET METHODS --------------------
    % set obj points position
    function obj = set.points(obj,pts)
      obj.points = pts;
    end
    % set obj y position
    function obj = set.missed(obj,msd)
      obj.missed = msd;
    end

    % -------------------- FUNCTIONAL METHODS --------------------
    function addPoint(obj)
      obj.points = obj.points + 1;
    end
    function addMissed(obj)
      obj.missed = obj.missed + 1;
    end
  end

end
