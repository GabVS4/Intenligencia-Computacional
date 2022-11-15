%% Lendo os arquivos:
arquivo = fopen('column_3C.dat');
colunasArquivo = textscan(arquivo, '%f %f %f %f %f %f %s', 'Delimiter',',');

%% Codifica as classes de saída
N = length(colunasArquivo{7});
rotulosUnicos = unique(colunasArquivo{7});
colunasDeRotulo = zeros(N, length(rotulosUnicos));

for i = 1: N
    for j = 1 : length(rotulosUnicos)
        colunasDeRotulo(i, j) = strcmp(colunasArquivo{7}{i}, rotulosUnicos(j));
    end
end

%   EXEMPLO:
%Se Coluna = DH     ==>     1 0 0
%Se Coluna = SL     ==>     0 1 0
%Se Coluna = NO     ==>     0 0 1

dataset = [colunasArquivo{1}, colunasArquivo{2}, colunasArquivo{3}, colunasArquivo{4}, colunasArquivo{5}, colunasArquivo{6}, colunasDeRotulo];

%% Transforma vetores linha em coluna
X = dataset(:, 1:6)';
D = dataset(:, 7:9)';

%% Normalização dos dados
[n,~] = size(X);

for i = 1 : n
    x = X(i, :);
    X(i, :) = (x - mean(x)) / std(x);
end

neuronios = 30; % Cria o modelo da RBF com 30 neurônios na camada oculta
sigma = 15; % Setando um valor para o sigma

%% Separa 30% das amostras para teste e o resto para treino
amostrasTeste = 0.3;

acuracia = zeros(1, 10);
[~, n] = size(X);

%% EPOCAS:
[classes, amostras] = size(X);
[numClassesSaidas, ~] = size(D);

for epoca = 1 : 10 % Seta 10 épocas

    qtdAmostrasTeste = round(amostrasTeste * amostras);

    indicesAleatorio = randperm(length(X)); % Aleatorização dos indices

    X_treino = X(:, indicesAleatorio);
    Y_treino = D(:, indicesAleatorio);
    
    %Remove 30% das amostras de X_treino e as coloca em Y_teste
    X_teste = zeros(classes, qtdAmostrasTeste);
    Y_teste = zeros(numClassesSaidas, qtdAmostrasTeste);
    
    for i = 1 : qtdAmostrasTeste
        X_teste(:, i) = X_treino(:, i);
        X_treino(:, i) = [];
        Y_teste(:, i) = Y_treino(:, i);
        Y_treino(:, i) = [];
    end

    % Treinando o Modelo
    [p, ~] = size(X_treino);
    C = pesosCamadaOculta(p, neuronios);
    Z = saidaCamadaOculta(X_treino, C, neuronios, sigma);
    M = Y_treino * Z' / (Z * Z');

    % Realizando uma predição
    Z = saidaCamadaOculta(X_teste, C, neuronios, sigma);
    predicao = M * Z;

    % Uma acurácia é obtida comparando os testes com a predição
    [~, amostrasDeTeste] = size(Y_teste);

    [~, classePred] = max(predicao);
    [~, classeCerta] = max(Y_teste);

    acertos = classePred == classeCerta;
    acertosEmTeste = sum(acertos);
    acuracia(epoca) = acertosEmTeste / amostrasDeTeste;

    fprintf('Acurácia da %d° Época: %f\n', epoca, acuracia(epoca));
end

fprintf('Média das Acurácias: %f\n', mean(acuracia));

%% FUNÇÕES:
function C = pesosCamadaOculta(p, neuronios)    
    C = randn(p, neuronios); %Gera pesos aleatórios
end

function Z = saidaCamadaOculta(X, C, neuronios, sigma)
    [~, n] = size(X);
    Z = zeros(neuronios, n);

    for i = 1 : n % Passa por todos os elementos de entrada
        for indiceNeuronio = 1 : neuronios% Passa por todos os neurônios
            x = X(:, i); % Pega o elemento em questão
            centroide = C(:, indiceNeuronio); % Pega o centroide do elemento em questão
            u = norm(x - centroide); % Calcula-se a norma
            fu = exp(-u .^ 2 / (2 * sigma .^ 2)); % Função de ativação
            Z(indiceNeuronio, i) = fu;
        end
    end
    
    [~, n] = size(Z);
    Z = [(-1) * ones(1, n); Z];
end