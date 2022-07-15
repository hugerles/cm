clear all
clc


% Código utilizado para ilustrar alguns efeitos presentes em um sistema de
% comunicações. O código não leva em consideração codificadores de fonte ou
% de canal e assume very fast flat Rayleigh fading through an AWGN channel
% ou apenas an AWGN channel.

%%%%%%%%%%%%%%%%%%%%%%%%%%% AQUISIÇÃO DE DADOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sample rate (2x 4kHz -- Freqência de Nyquist para sinal de voz)
Fs = 8000;

% Aquisição dos dados - Gravação de áudio
r = audiorecorder(Fs,16,2); % Gravação em modo estério
record(r); % Início da gravação
pause(8); % Gravando por aproximadamento 8s
stop(r); % Fim da gravação
mySpeech = getaudiodata(r); % Matriz com dados de da gravação

%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PARÂMETROS DO SISTEMA %%%%%%%%%%%%%%%%%%%%%%%%%%

k = 10; % Número de bits do quantizador -- Quantizador com passo uniforme
M = 2; % Ordem da Constelação M-QAM para Transmissão 
SNR_dB = 20; % Relação sinal-ruído do sistema

flag = 1; % Flag = 1 -> Rayleigh, Flag ~= 1 -> AWGN

% Seleção de apenas um dos canais de aúdio 
mySpeech = mySpeech(:,1);

%%

% Etapa de Digitalização
maxx = 1.5*max(max(mySpeech)); % Valor máximo do quantizado
minn = 1.5*min(min(mySpeech)); % Valor mínimo do quantizado
[coded,quant,qt_sig] = quantizer(maxx,minn,k,mySpeech); % Quantizador

N_bits_tras = length(coded); % Número de bits transmitido

% Etapa de Transmissão/Recepção
[dados_p2s,ber] = channel(M,coded,SNR_dB,flag);


% Essa etapa é necessária para corrigir o número de bits recebidos.
% Não tem função física ou de sistema, é apenas um flag utilizado para que
% o número de bits recebidos seja igual ao número de bits efetivamente
% transmitidos. Em algumas ordens de constelação, a razão entre a quantidade
% de bits que sai do quantizador (N_bits_tras) e a quantidade de bits por
% símbolo (log2(M)) não é um número inteiro, então "faltam bits para
% completar um símbolo". Assim, na função "channel" eu completo esses bits
% que faltaram e posteriormente preciso removê-los para reconstruir o sinal
% corretamente
% % Correção no Número de bits
N = length(dados_p2s);
if mod(N,k) ~= 0 % Correção no número de bits
    N = N+k-mod(N,k);
    dados_p2s = cat(1,dados_p2s,randi([0 1],N-length(dados_p2s),1));
end


% Reconstrução do Sinal
dat = reshape(dados_p2s,length(dados_p2s)/k,k);
dat = bi2de(dat)+ones(length(dat),1);

% Sinal reconstruído
data = quant(dat);

% Bit error rate
ber

% Etapa de frescurinha para ajustar o gráfico com os mesmos limites nos
% eixos
coef = max(abs(max(data)),abs(min(data)));
tr = linspace(0,5,length(mySpeech));
tf = linspace(0,5,length(data));
lim = [0 max(tr) -1.1*coef 1.1*coef];


figure(1)
subplot(3,1,1)
plot(tr,mySpeech,'r')
% xlabel('$$t$$~(s)','Interpreter','Latex','FontSize',16)
ylabel('$$s(t)$$','Interpreter','LaTex','FontSize',16)
title('Sinal Amostrado','Interpreter','LaTex','FontSize',16)
% title('')
axis(lim)
subplot(3,1,2)
plot(tr,qt_sig,'b')
% xlabel('$$t$$~(s)','Interpreter','Latex','FontSize',12)
ylabel('$$\overline{s}(t)$$','Interpreter','LaTex','FontSize',16)
title('Sinal Quantizado','Interpreter','LaTex','FontSize',16)
% title('')
axis(lim)
subplot(3,1,3)
plot(tf,data,'g')
axis(lim)
% xlabel('$$t$$~(s)','Interpreter','Latex','FontSize',16)
ylabel('$$\hat{s}(t)$$','Interpreter','LaTex','FontSize',16)
title('Sinal Estimado -- 10~dB','Interpreter','LaTex','FontSize',16)

%%

% Som adiquirido
sound(mySpeech,Fs)

%%

% Sinal após o quantizador
sound(qt_sig,Fs)

%%

% Som Quantizado, Transmitido e recebido
sound(data,Fs)

