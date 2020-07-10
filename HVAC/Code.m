length_1 = 20; %house length parameters
length_2 = 10;
length_3 = 4;
beta = 40; %roof angle
N_win = 4; %number of windows
N_wall = 1; %number of walls "all in one"
areaWin = 1; %area of windows
areaWall = 236; %area off walls
thermWall = 136.8; %wall thermal coeffient
thermWin = 2808; %window thermal coeffient
thickWin = 0.07; %thickness of windows 
thickWall = 0.2; %thickness of walls
airDen = 1.225; %air density
ca = 1.01; %thermal capasity of air
COP = 2; %coeffiecient of performance
P = 3; %power 3KW

Volume = (length_1*length_2*length_3) + (tand(beta)*length_1*length_2); %house volume
mass = Volume*airDen;
R_win = (1/N_win) * (thickWin/(thermWin*areaWin)); %resistance of windows
R_wall = (1/N_wall) * (thickWall/(thermWall*areaWall)); %resistance of walls
Rh = 1/(1/R_wall + 1/R_win); %paralel circuit
fprintf("Volume = %.10f\n",Volume)
fprintf("Mass = %.10f\n",mass)
fprintf("Walls' R = %.10f\n",R_wall)
fprintf("Windows' R = %.10f\n",R_win)
fprintf("Rh = %.10f\n\n",Rh)

deltaT = 0.1; %6 minutes period of an hour = 6/60
Tini = 19; %initial temp starts with fav temp of household's owner
Tout = 30; %for debugging
Ptotal = 0; %total power consumption counter
for t = 12:0.1:16
    fprintf("Time = %.2f\n",t);
    fprintf("Tin,h = %.2f\n\n",Tini);
    plot(t,Tini,'r-o');
    xlabel("Time")
    ylabel("T_in,h")
    grid on
  if (t>12) && (t<14)
    Tout = 30; %12am-14am outside temperature
  elseif (t>14.9) && (t<15)
    Tout = 31; %14am-15am outside temperature
  elseif (t>15.9) && (t<16)
    Tout = 30; %15am-16am outside temperature
  end
  if Tini<21
    U = 0; %HVAC is OFF
  else
    U = 1; %HVAC is ON
  end
hold on
Tini=((1-(deltaT/(1000*mass*ca*Rh)))*Tini+(deltaT/(1000*mass*ca*Rh))*Tout-U*((COP*P*deltaT)/(0.000277*mass*ca)));
Ptotal = Ptotal + P*U; %total power
end
fprintf("Total Power Consumption = %.d KW\n",Ptotal)