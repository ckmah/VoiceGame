% Logic:
function f = Logic()
  % f = 0;

  % STATE VARIABLES
  STATE_FAILURE = -1;
  STATE_INIT = 0;
  STATE_ACQUISITION = 1;
  STATE_ACQUIRED = 2;

  %% Define computer-specific variables
  ipA = '128.54.165.120';  portA = 8052;   % Modify these values to be those of your first computer.
  ipB = '128.54.162.200';  portB = 8051;  % Modify these values to be those of your second computer.

  time = 0; % relative time (x-axis)
  DELAY = 0.1; % pause between iterations

  % PLAYER
  myposx = 0; % track my position on x-axis (should always match time)
  myposy = 0; % track my position on y-axis (user controllable)
  p = 0; % player object

  % TARGET
  targetx = 0; % instantiate target xpos
  targety = 0; % instantiate target ypos
  targets = zeros(1,5);

  % KEYBOARD KEY VALUES
  % KbName('UnifyKeyNames');
  kc_return = KbName('Return');
  kc_up = KbName('up');
  kc_down = KbName('down');

  current_state = STATE_INIT; % track state

  startTime = GetSecs; % relative start time

  % main runtime
  while 1
    switch current_state
      % initialization
      case STATE_INIT
        % generate new random target here?
        % targetx = 10; % target position in time
        % targety = 10; % target position (changes?)

        % first initialization
        if size(targets) == 0
          p = Player(0,0,5,true); % generate Player object

          % generate targets
          for n = 1:5
            targets(n) = Target(n*50,10,2,true);
          end
        end

        udpA = udp(ipB,portB,'LocalPort',portA); % Create UDP Object
        fopen(udpA) % Connect to UDP Object

        current_state = STATE_ACQUISITION;

      % constant check for acquisition
      case STATE_ACQUISITION
        % DEBUG
        % fprintf('%s%d, ', 'myposx(time) = ', myposx);
        % fprintf('%s%d, ', 'myposy = ', myposy);
        % fprintf('%s%d, ', 'targetx = ', targetx);
        % fprintf('%s%d\n', 'targety = ', targety);

        % CONDITION
        % if time > targetx % player has passed target
        %   current_state = STATE_FAILURE;
        % elseif myposx == targetx && myposy == targety % player collision with target
        %   current_state = STATE_ACQUIRED;
        % end

      % target acquired
      case STATE_ACQUIRED
        fprintf('%s', 'Holding...');
        current_state = STATE_INIT;

      % missed target
      case STATE_FAILURE
        fprintf('Failed to acquire target.');
        break;
      otherwise
        % Do additional computations, possibly including more calls to KbQueueCheck, etc
        KbQueueRelease;
        f = error('Invalid state.');
        return;
    end

    [keyIsDown ctime keycodes] = KbCheck(); % check for pressed keyboard keys

    if keyIsDown
      pressedCodes = find(keycodes);
      for i = 1:size(pressedCodes,2)
        % fprintf('The %s key was pressed at time %.3f seconds\n', KbName(pressedCodes(i)), keycodes(pressedCodes(i))-startTime);
        % fprintf(udpA, KbName(pressedCodes(i)));

        fprintf(udpA, strcat('player,', p.x, p.y, ',5,true\n'))
        % fprintf(udpA, p.x)
        % fprintf(udpA, strcat(p.y, ',5,true\n'))
        % fprintf('%s,', p.radius);
        % fprintf('%s\n', p.visible);

        % exit on return
        if pressedCodes(i) == kc_return
          %% Clean Up Machine A
          fclose(udpA)
          delete(udpA)
          clear ipA portA ipB portB udpA
          return;

        % move player up y-axis one unit
        elseif pressedCodes(i) == kc_up
          myposy = myposy + 1
        % move player up y-axis one unit
        elseif pressedCodes(i) == kc_down
          myposy = myposy - 1
        end
      end
    else
      fprintf('No key presses detected\n');
    end

    time = time + 1; % increment
    myposx = time;
    p.x = time;
    p.y = myposy;

    pause(DELAY);
  end
end

