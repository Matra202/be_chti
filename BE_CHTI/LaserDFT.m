close all;
F1 = 85000*2*pi;
F2 = 90000*2*pi;
F3 = 95000*2*pi;
F4 = 100000*2*pi;
F5 = 115000*2*pi;
F6 = 120000*2*pi;
Fe = 320000;
F = 5000;
T = 1/F;
Te = 1/Fe;
M = T/Te;
Tsim = T-Te;
Res = sim('SimulLaserDFT');
%plot(Res.Laser_Continu);
%for index=1:16 
    %Res.Laser_Echanti.Data(index)=0;
%end
%hold on; % permet de superposer la courbe à suivre
plot(Res.Laser_Echanti,'-');
Y = fft(Res.Laser_Echanti.Data(),M);
tab31 = linspace(0,(M-1),M);
tabHz = linspace(0/T,(M-1)/T,M);
figure();
semilogy(tabHz,abs(Y/M),'x');
s = tf('s'); H = 1/(1.7e-23*s^4+7.7e-18*s^3+1.2e-11*s^2+3e-6*s+1);
figure();
bode(H);
