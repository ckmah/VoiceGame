function f = KeyListenerDemo()

  kc_up = KbName('UpArrow');
  kc_down = KbName('DownArrow');

  while 1

      wtime = KbWait();      % note that KbWait introduces a small (~1-2 ms) delay
      [keyIsDown ctime keycodes] = KbCheck();

      % Check that pressed keycodes and the desired codes overlap
      % If so, then exit loop
      if keycodes(kc_up)
          disp('You pressed Up');
          break
      elseif keycodes(kc_down)
          disp('You pressed Down');
          break
      end
  end

  disp(['Time between KbWait and KbCheck, in milliseconds: ' num2str(1000*(ctime-wtime))]);

end
