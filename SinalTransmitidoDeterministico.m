clear all
clc

M = 16;
t = linspace(0,1,4e3);
s =@(i,q) (i*cos(2*pi*3*t)-q*sin(2*pi*3*t));
comp =@(i) 2*i-1-sqrt(M);

S = [];
for i = 1:sqrt(M)
    for j = 1:sqrt(M)
        S = cat(2,S,s(comp(i),comp(j)));
    end
end


f = -200:.1:200;
X = zeros(length(f),1);
t = linspace(0,(M),length(S));
for k = 1 : length(f)
     X(k) = trapz(t,S.*exp(-1j*2*pi*f(k)*t));
end


figure(4)
subplot(2,1,1)
plot(t,S,'r','linewidth',1.0)
xlabel('$$kT_{s}$$','Interpreter','Latex','FontSize',16)
ylabel('$$s(t)$$','Interpreter','LaTex','FontSize',16)
title('Sinal transmitido','Interpreter','LaTex','FontSize',16)
subplot(2,1,2)
plot(t,S+normrnd(0,sqrt(1)/2,[1 length(S)]),'b','linewidth',1.0)
xlabel('$$kT_{s}$$','Interpreter','Latex','FontSize',16)
ylabel('$$r(t)$$','Interpreter','LaTex','FontSize',16)
title('Sinal recebido','Interpreter','LaTex','FontSize',16)
% axis([min(kappa) max(kappa) 1.5e-1 2.5e-1])
grid on

% Espectro
figure(5)
plot(f,abs(X))
xlabel('f')
ylabel('|P(f)|')

