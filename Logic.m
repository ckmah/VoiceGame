% Logic: function description
function f = Logic()
  f = 0;

% STATE VARIABLES
  STATE_FAILURE = -1;
  STATE_INIT = 0;
  STATE_ACQUISITION = 1;
  STATE_ACQUIRED = 2;

  time = 10; % relative time (x-axis)
  DELAY = 0.05; % pause between iterations

  % OBJECT POSITIONS
  myposx = 10; % track my position on x-axis (should always match time)
  myposy = 0; % track my position on y-axis (user controllable)
  targetx = 0; % instantiate target xpos
  targety = 0; % instantiate target ypos

  % KEYBOARD KEY VALUES
  kc_up = KbName('up');
  kc_down = KbName('down');

  current_state = STATE_INIT; % track state

  % KbQueueCreate; % initialize keyboard queue
  startTime = GetSecs; % relative start time
  % KbQueueStart; % start retrieveing keyboard input

  % main runtime
  while 1
    switch current_state
      % initialization
      case STATE_INIT
        % generate new random target here?
        targetx = 10; % target position in time
        targety = 10; % target position (changes?)
        current_state = STATE_ACQUISITION;

      % constant check for acquisition
      case STATE_ACQUISITION
        % DEBUG
        fprintf('%s%d, ', 'myposx(time) = ', myposx);
        fprintf('%s%d, ', 'myposy = ', myposy);
        fprintf('%s%d, ', 'targetx = ', targetx);
        fprintf('%s%d\n', 'targety = ', targety);

        % CONDITION
        if time > targetx
          current_state = STATE_FAILURE;
        elseif myposx == targetx && myposy == targety
          current_state = STATE_ACQUIRED;
        end

      case STATE_ACQUIRED
        fprintf('%s', 'Holding...');
        current_state = STATE_INIT;
      case STATE_FAILURE
        fprintf('Failed to acquire target.');
        break;
      otherwise
        % Do additional computations, possibly including more calls to KbQueueCheck, etc
        KbQueueRelease;
        f = error('Invalid state.');
        return;
    end

    % Do some other computations, display things on screen, play sounds, etc
    % [ pressed, firstPress] = KbQueueCheck; % Collect keyboard events since KbQueueStart was invoked
    [keyIsDown ctime keycodes] = KbCheck();

    if keyIsDown
      pressedCodes = find(keycodes);
      for i = 1:size(pressedCodes,2)
        fprintf('The %s key was pressed at time %.3f seconds\n', KbName(pressedCodes(i)), keycodes(pressedCodes(i))-startTime);
        if pressedCodes(i) == kc_up
          myposy = myposy + 1
        elseif pressedCodes(i) == kc_down
          myposy = myposy - 1
        end
      end
    else
      fprintf('No key presses were detected\n');
    end


    % function movePlayerPos(src, event)


    % time = time + 1; % increment
    myposx = time;
    % myposy = time;
    pause(DELAY);
  end
end
