function udpdemo =  UDPdemo()
  %% Define computer-specific variables
  ipA = '137.110.63.45';   portA = 49170;   % Modify these values to be those of your first computer.
  ipB = '169.228.172.179';  portB = 9051;  % Modify these values to be those of your second computer.

  %% Create UDP Object
  udpA = udp(ipB,portB,'LocalPort',portA);

  %% Connect to UDP Object
  fopen(udpA)

  % while true
    fprintf(udpA,'OMFG THIS TOOK FIVEVER.');
  % end

  %% Clean Up Machine A
  fclose(udpA)
  delete(udpA)
  clear ipA portA ipB portB udpA
end
