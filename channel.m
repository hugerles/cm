function [dados_p2s,ber] = channel(M,coded,SNR_dB,flag)

% N�mero de bits na sa�da do quantizador
Ni = length(coded);

% Corre��o do n�mero de bits para quando Ni/Log2(M) n�o for inteiro
N = length(coded);
k = log2(M); % N�mero de bits por s�mbolo
if mod(N,log2(M)) ~= 0 % Corre��o no n�mero de bits
    N = N+log2(M)-mod(N,log2(M));
    coded = cat(1,coded,randi([0 1],N-length(coded),1));
end

% Pot�ncia do sinal
Ps = 1/log2(M);
% Pot�ncia do ru�do
Pn = Ps.*10.^(-0.1*SNR_dB);

dados = coded; % Sequ�ncia bin�ria
dados_s2p = reshape(dados,N/k,k); % Convers�o S�rie-Paralelo
dados_dec = bi2de(dados_s2p); % Convers�o binario-decimal para futura
                              % correla��o coms os s�mbolos da
                              % constela��o

s = qammod(0:1:M-1,M,'UnitAveragePower',true); % Gera��o dos s�mbolos da constela��o
                                               % utilizando mapeamento Gray

n =    normrnd(0,sqrt(Pn/2),[1 length(dados_dec)])+...
    1j*normrnd(0,sqrt(Pn/2),[1 length(dados_dec)]); % Ru�do AWGN

if flag == 1
    fading =    normrnd(0,1/sqrt(2),[1 length(dados_dec)])+...
             1j*normrnd(0,1/sqrt(2),[1 length(dados_dec)]);
else
    fading = 1;
end

% Sinal recebido ap�s equalizado -- Estima��o perfeita do estado do canal
r = s(dados_dec+1) + n./fading;

% Demodula��o do sinal recebido
demod = qamdemod(r,M,'UnitAveragePower',true);

% Convers�o decimal to binary
dados_demod = de2bi(demod,k);
% Sequ�ncia de bits recebidas ap�s o demodulador
dados_p2s = dados_demod(:);

[~,ber] = biterr(coded,dados_p2s);

dados_p2s = dados_p2s(1:Ni);

% Constela��o recebida e transmitida
figure(123)
plot(real(r),imag(r),'.',...
     real(s),imag(s),'x',...
     'linewidth',1.5)
axis(1.5*[-1 1 -1 1])
end