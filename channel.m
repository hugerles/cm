function [dados_p2s,ber] = channel(M,coded,SNR_dB,flag)

% Número de bits na saída do quantizador
Ni = length(coded);

% Correção do número de bits para quando Ni/Log2(M) não for inteiro
N = length(coded);
k = log2(M); % Número de bits por símbolo
if mod(N,log2(M)) ~= 0 % Correção no número de bits
    N = N+log2(M)-mod(N,log2(M));
    coded = cat(1,coded,randi([0 1],N-length(coded),1));
end

% Potência do sinal
Ps = 1/log2(M);
% Potência do ruído
Pn = Ps.*10.^(-0.1*SNR_dB);

dados = coded; % Sequência binária
dados_s2p = reshape(dados,N/k,k); % Conversão Série-Paralelo
dados_dec = bi2de(dados_s2p); % Conversão binario-decimal para futura
                              % correlação coms os símbolos da
                              % constelação

s = qammod(0:1:M-1,M,'UnitAveragePower',true); % Geração dos símbolos da constelação
                                               % utilizando mapeamento Gray

n =    normrnd(0,sqrt(Pn/2),[1 length(dados_dec)])+...
    1j*normrnd(0,sqrt(Pn/2),[1 length(dados_dec)]); % Ruído AWGN

if flag == 1
    fading =    normrnd(0,1/sqrt(2),[1 length(dados_dec)])+...
             1j*normrnd(0,1/sqrt(2),[1 length(dados_dec)]);
else
    fading = 1;
end

% Sinal recebido após equalizado -- Estimação perfeita do estado do canal
r = s(dados_dec+1) + n./fading;

% Demodulação do sinal recebido
demod = qamdemod(r,M,'UnitAveragePower',true);

% Conversão decimal to binary
dados_demod = de2bi(demod,k);
% Sequência de bits recebidas após o demodulador
dados_p2s = dados_demod(:);

[~,ber] = biterr(coded,dados_p2s);

dados_p2s = dados_p2s(1:Ni);

% Constelação recebida e transmitida
figure(123)
plot(real(r),imag(r),'.',...
     real(s),imag(s),'x',...
     'linewidth',1.5)
axis(1.5*[-1 1 -1 1])
end