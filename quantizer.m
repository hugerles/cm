function [coded,quanti,qt_sig] = quantizer(minn,maxx,k,x)
% Função que recebe os dados (x), os limites superior e 
% inferior do quantizador (maxx e minn) e o número 
% de bits do mesmo (k). A saída da função é composta
% pelos bits a serem transmitidos (coded), pelo sinal quantizado (qt_sig)
% e pelos representantes do quantizado que serão utilizados
% para reconstruir o sinal (quanti)


quanti = linspace(minn,maxx,2^k); % Valores do Quantizador

% Disposição dos valores do quantizador em uma matriz com repetição (*)
mat = ones(length(x),2^k);
for i = 1:2^k
    mat(:,i) = mat(:,i)*quanti(i);
end

% Disposição dos dados em uma matriz com repetição (**)
dat = ones(length(x),2^k);
for i = 1:length(x)
    dat(i,:) = dat(i,:)*x(i);
end

% * e ** foram realizados para reduzir o número de operações na busca entre
% os representantes dos x(i)s, realizada na etapa abaixo. Há formas mais
% eficientes de realizar essa tarefa, como por exemplo, utilizando a função
% repmat. O matlab já possui funções que realizam essa quantização, mas
% optei por implementá-la para apresentar o conceito.

[~,ind] = min(abs(dat-mat).'); % Identificação do índice do representante
% de cada x(i) -- o índice escolhido é o que apresenta a menor diferença
% entre o vetor [x(i) x(i) ... x(i) x(i)] (comprimento 2^k) e o vetor 
% [quanti(1) quanti(2) ... quanti(2^k)]


% Sinal quantizado. Quanto menor o k, maior o erro de quantização
qt_sig = quanti(ind); % Sinal Quantizado


% Índices do quantizador que representam o sinal quantizado -- Informação
% que será de fato transmitida
ind = ind - ones(1,length(ind));

% Conversão decimal to binary
coded = de2bi(ind,k);

% Conversão paralelo/série para futura transmissão
coded = coded(:);

end