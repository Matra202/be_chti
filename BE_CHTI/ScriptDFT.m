close all;
Fsin = 14 ;
T = 2/(Fsin);
M=32; %M=T/Te
Te = T/M;
Tsim = T-Te;
Res = sim('SimulDFT');
plot(Res.Sinus_Continu);
hold on; % permet de superposer la courbe à suivre
plot(Res.Sinus_Echanti,'o');
Y = fft(Res.Sinus_Echanti.Data(),M);
tab31 = linspace(0,(M-1),M);
tabHz = linspace(0/T,(M-1)/T,M);
figure();
hold on;
plot(tabHz,abs(Y/M),'x');