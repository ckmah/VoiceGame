% Logic function provides the game logic for a voice prosthetic game interface.
% A player aims to capture targets scrolling across the screen by keyboard input/voice input.
function f = Logic()

  % STATE VARIABLES
  STATE_FAILURE = -1;
  STATE_INIT = 0;
  STATE_ACQUISITION = 1;
  STATE_ACQUIRED = 2;

  %% Define computer-specific variables
  ipA = '137.110.62.104';  portA = 8052;   % Modify these values to be those of this computer.
  ipB = '137.110.62.56';  portB = 8051;  % Modify these values to be those of the receiving computer.

  time = 0; % relative time (x-axis)
  DELAY = 0.1; % pause between iterations

  p = 0; % player object

  % TARGET
  NUMTARGETS = 10;
  targets(NUMTARGETS) = Target();

  % KEYBOARD KEY VALUES
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

        generate targets
        for n = 1:10
           targets(n) = Target(n*50,10,2,true);
        end

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
        KbQueueRelease; % clear keyboard queue
        f = error('Invalid state.');
        return;
    end

    [keyIsDown ctime keycodes] = KbCheck(); % check for pressed keyboard keys

    if keyIsDown
      pressedCodes = find(keycodes);
      for i = 1:size(pressedCodes,2)
        % format player data output
        pdata = strcat('player,', num2str(p.x), ',', num2str(p.y), ',', num2str(p.radius), ',', num2str(p.visible), ';');
        tdata = '';

        % format target data output
        for n = 1:10
          tdata = strcat(tdata, 'target,', num2str(targets(n).x), ',', num2str(targets(n).y), ',', num2str(targets(n).radius), ',', num2str(targets(n).visible), ';');
        end

        data = strcat(pdata, tdata);
        disp(pdata); % debug print
        fprintf(udpA, pdata); % UDP output

        fprintf(udpA, strcat(num2str(TEMP), '0000'));

        % exit on return
        if pressedCodes(i) == kc_return
          %% clean up
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
    end

    time = time + 1; % increment
    p.x = time;
    pause(DELAY);
  end
end

