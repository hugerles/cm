clear
clc

% This piece of code may be used to analyze the effect of the Sample rate.
% In order to recover the signal, Nyquist rule MUST be obeyed

% Aquisição do sinal
% Sample rate (2x 4kHz -- Freqência de Nyquist para sinal de voz)
Fs = 8000;

% Aquisição dos dados - Gravação de áudio
r = audiorecorder(Fs,16,2); % Gravação em modo estério
record(r); % Início da gravação
pause(4); % Gravando por aproximadamento 8s
stop(r); % Fim da gravação
mySpeech = getaudiodata(r); % Matriz com dados de da gravação

% Seleção do canal de áudio
mySpeech = mySpeech(:,1);


%%

% Realização da transformada de Fourier de "TEMPO CONTÍNUO"
t = linspace(0,3,length(mySpeech)).';
f = -8000:1:8000;
X = zeros(length(f),1);

for k = 1 : length(f)
     X(k) = trapz(t,mySpeech.*exp(-1j*2*pi*f(k)*t));
end

%%

figure(4)
subplot(3,1,1)
plot(t,mySpeech)
xlabel('t')
ylabel('p(t)')
subplot(3,1,2)
plot(f,abs(X))
xlabel('f')
ylabel('|P(f)|')
subplot(3,1,3)
plot(f,180*phase(X)/pi)
xlabel('\omega')
ylabel('|\theta(\omega)|')

%%

sound(mySpeech,Fs)

