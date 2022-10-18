base = load("aerogerador.dat"); %carregando os dados do problema

x = base(:, 1); %velocidade do vento
y = base(:, 2); %potência

n = length(x); %número de amostras

X = [ones(n, 1) x x.^2 x.^3]; %vetor dos valores da velocidade do vento

beta = ((X' * X) \ (X' * y));

%funcão de regressão múltipla
Y = beta(1) + beta(2) * x + beta(3) * x.^2 + beta(4) * x.^3;

%Mostragem dos dados
plot(x, y, '*', x, Y, 'r-');

R2 = 1 - (sum((y - Y).^2)) / (sum((y - mean(y)).^2)); %coeficiente de determinação
fprintf('R2 = %f\n', R2);

[L, C] = size(X); %número de linhas e colunas
k = C - 1; %número de termos
p = k + 1;

R2_aj = 1 - ((sum((y - Y).^2)) / (n - p)) / ((sum((y - mean(y)).^2)) / (n-1)); %coeficiente de determinação ajustado
fprintf('R2 ajustado = %f\n', R2_aj);
