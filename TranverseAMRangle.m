% this program is tune into the transport data to get the following values:
% Keeping B1 (1.67*10^7) constant determine the value of Strain
% Keeping Strain constant find the value of B2 for layer 2
close all
% Get the raw Rxy data at specific  V for [110] direction

% Calibration factors from magnet calibration:
% d=-1.658-3.615; % for downcycle
% u=1.523; % for up
% d1=0.3;u1=-0.3;
% % d2=3.4;u2=-3.4;
% d2=2.925;u2=-2.7;
d1=-5.125*10^-4;u1=-5.125*10^-4;
% d2=3.4;u2=-3.4;
d2=2.2525*10^-4;u2=2.2525*10^-4;
filepath1='F:\Documents\Documents\blog stuff\Rxy_example.txt';
r1=strrep(filepath1,'.txt','');
fileID1=fopen(filepath1);
formatSpec='%f';
A1 = fscanf(fileID1,formatSpec);
% A=A';
l1=length(A1);
Bre = reshape(A1,2,[]);
B1re=Bre';

Xdata1=(B1re(:,1));
Xup=(Xdata1(1:length(Xdata1)/2));%+u1+u2;
Xdown=(Xdata1(length(Xdata1)/2:end));%+d1+d2;
Xc=[Xup',Xdown'];
%Xc=Xc/1000;
% for in=1:1:13
Ydata1=B1re(:,2);
Ydata1=Ydata1;
Yup=Ydata1(1:length(Ydata1)/2);
Ydown=Ydata1(length(Ydata1)/2:end);
Yc=[Yup',Ydown'];
Rxyup=Ydata1(1:length(Xdata1)/2);
Rxydown=Ydata1(length(Xdata1)/2:end);
Rxyc=[Rxyup',Rxydown'];

% Normalising the  transverse resistance between -1 and +1
rxyminup=min(Rxyup);rxymaxup=max(Rxyup);indUp=find(Rxyup==rxyminup);% index of min in up cycle
rxymindown=min(Rxydown);rxymaxdown=max(Rxydown);indDn=find(Rxydown==rxymindown);% index of min in up cycle
rxyupN=((Rxyup-rxyminup)/(rxymaxup-rxyminup)-0.5)*2;
rxydownN=((Rxydown-rxymindown)/(rxymaxdown-rxymindown)-0.5)*2;
rxy=[rxyupN',rxydownN'];
figure(1)
plot((Xup/1000),rxyupN,'-b'); hold on
plot((Xdown/1000),rxydownN,'-r'); hold on
xlabel('Magnetic field (T)')
ylabel('Rxy (\Omega)');
% title([' Experimental Rxy for H= ',num2str(Bdir),' degrees from [010] at ',num2str(V(in)),' V']);
grid on;
grid minor;
% Find the Switching fields for one sweep directon:
% Say the down sweep is considered (the red curve)
[M,I] = min(rxydownN);
X1=Xdown(1:I-1); rxydownN1=abs(rxydownN(1:I-1));
X2=Xdown(I:I+2); rxydownN2=rxydownN(I:I+2)*0;
X3=Xdown(I+3:end);rxydownN3=-rxydownN(I+3:end);
X=[X1;X2;X3];
XYD=[rxydownN1;rxydownN2;rxydownN3];

% Normalising points between +-1
rxydownN1=(1-rxydownN1)+rxydownN1;
rxydownN3=(-1-rxydownN3)+rxydownN3;
XYD=[rxydownN1;rxydownN2;rxydownN3];
figure(2)
plot(X,XYD,'-ok');
MI1=asind(XYD);
figure(3)
plot(X,MI1,'-sr'); hold on
plot(flipud(X),-MI1,'-ok'); hold on
legend('Down-sweep,','Up-sweep');
xlabel('Magnetic field (T)');
ylabel('Angle (\theta_M)');
title('Magnetisation angle calculated from Tr-AMR wrt [010]');


