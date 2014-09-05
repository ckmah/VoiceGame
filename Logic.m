function f = Logic()
  % f = 0;

  % STATE VARIABLES
  STATE_FAILURE = -1;
  STATE_INIT = 0;
  STATE_ACQUISITION = 1;
  STATE_ACQUIRED = 2;

  %% Define computer-specific variables
  ipA = '137.110.63.45';  portA = 9052;   % Modify these values to be those of your first computer.
  ipB = '169.228.172.179';  portB = 9051;  % Modify these values to be those of your second computer.

  time = 0; % relative time (x-axis)
  DELAY = 0.1; % pause between iterations

  % PLAYER
  % myposx = 0; % track my position on x-axis (should always match time)
  % myposy = 0; % track my position on y-axis (user controllable)
  p = 0; % player object

  % TARGET
  %targetx = 0; % instantiate target xpos
  %targety = 0; % instantiate target ypos
  NUMTARGETS = 10;
  targets(NUMTARGETS) = Target();

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
        disp('Initializing new player...');
        p = Player(1,1,5,true); % generate Player object

        % generate targets
        % for n = 1:10
        %    targets(n) = Target(n*50,10,2,true);
        % end

        udpA = udp(ipB,portB,'LocalPort',portA); % Create UDP Object
        fopen(udpA); % Connect to UDP Object

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

      % missed target/other case?
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

        % format player data output
        pdata = strcat('player,', num2str(p.x), ',', num2str(p.y), ',', num2str(p.radius), ',', num2str(p.visible), ';');
        tdata = '';

        % format target data output
        for n = 1:10
          % tdata = strcat(tdata, 'target,', num2str(targets(n).x), ',', num2str(targets(n).y), ',', num2str(targets(n).radius), ',', num2str(targets(n).visible), ';');
        end

        % data = strcat(pdata, tdata);
        data = strcat(num2str(10),',',num2str(1));
        disp(pdata); % debug print
        fprintf(udpA, pdata); % UDP output

        % exit on return
        if pressedCodes(i) == kc_return
          %% Clean Up Machine A
          fclose(udpA);
          delete(udpA)
          clear ipA portA ipB portB udpA
          return;
        % move player up y-axis one unit
        elseif pressedCodes(i) == kc_up
          p.y = p.y + 1;
        % move player up y-axis one unit
        elseif pressedCodes(i) == kc_down
          p.y = p.y - 1;
        end
      end
    else
      % fprintf('No key presses detected\n');
    end

    time = time + 1; % increment
    p.x = time;
    pause(DELAY);
  end
end

