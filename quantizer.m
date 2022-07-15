function [coded,quanti,qt_sig] = quantizer(minn,maxx,k,x)
% Fun��o que recebe os dados (x), os limites superior e 
% inferior do quantizador (maxx e minn) e o n�mero 
% de bits do mesmo (k). A sa�da da fun��o � composta
% pelos bits a serem transmitidos (coded), pelo sinal quantizado (qt_sig)
% e pelos representantes do quantizado que ser�o utilizados
% para reconstruir o sinal (quanti)


quanti = linspace(minn,maxx,2^k); % Valores do Quantizador

% Disposi��o dos valores do quantizador em uma matriz com repeti��o (*)
mat = ones(length(x),2^k);
for i = 1:2^k
    mat(:,i) = mat(:,i)*quanti(i);
end

% Disposi��o dos dados em uma matriz com repeti��o (**)
dat = ones(length(x),2^k);
for i = 1:length(x)
    dat(i,:) = dat(i,:)*x(i);
end

% * e ** foram realizados para reduzir o n�mero de opera��es na busca entre
% os representantes dos x(i)s, realizada na etapa abaixo. H� formas mais
% eficientes de realizar essa tarefa, como por exemplo, utilizando a fun��o
% repmat. O matlab j� possui fun��es que realizam essa quantiza��o, mas
% optei por implement�-la para apresentar o conceito.

[~,ind] = min(abs(dat-mat).'); % Identifica��o do �ndice do representante
% de cada x(i) -- o �ndice escolhido � o que apresenta a menor diferen�a
% entre o vetor [x(i) x(i) ... x(i) x(i)] (comprimento 2^k) e o vetor 
% [quanti(1) quanti(2) ... quanti(2^k)]


% Sinal quantizado. Quanto menor o k, maior o erro de quantiza��o
qt_sig = quanti(ind); % Sinal Quantizado


% �ndices do quantizador que representam o sinal quantizado -- Informa��o
% que ser� de fato transmitida
ind = ind - ones(1,length(ind));

% Convers�o decimal to binary
coded = de2bi(ind,k);

% Convers�o paralelo/s�rie para futura transmiss�o
coded = coded(:);

end