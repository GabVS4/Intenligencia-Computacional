%% Lendo os arquivos:
arquivo = fopen('column_3C.dat'); 
colunasArquivo = textscan(arquivo, '%f %f %f %f %f %f %s', 'Delimiter',',');

%% Codifica as classes de saída
N = length(colunasArquivo{7});
rotulosUnicos = unique(colunasArquivo{7});
colunasDeRotulos = zeros(N, length(rotulosUnicos)); %N linhas e 3 colunas

for i = 1: N %Percorre os rótulas para cada amostra
    for j = 1 : length(rotulosUnicos)
        colunasDeRotulos(i, j) = strcmp(colunasArquivo{7}{i}, rotulosUnicos(j));
    end
end

%   EXEMPLO:
%Se Coluna = DH     ==>     1 0 0
%Se Coluna = SL     ==>     0 1 0
%Se Coluna = NO     ==>     0 0 1

dataset = [colunasArquivo{1}, colunasArquivo{2}, colunasArquivo{3}, colunasArquivo{4}, colunasArquivo{5}, colunasArquivo{6}, colunasDeRotulos];

%% Transforma vetores linha em coluna
X = dataset(:, 1:6)';
D = dataset(:, 7:9)';

%% Normalização dos dados
[n,~] = size(X);

for i = 1 : n
    x = X(i, :);
    X(i, :) = (x - mean(x)) / std(x);
end

rede = feedforwardnet(40);% Gera um MLP com 40 neurônios ocultto

%% Separa 30% das amostras para teste e o resto para treino
amostrasTeste = 0.3;
somaAcuracia = 0;

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

    rede = train(rede, X_treino, Y_treino); % Treinando o Modelo
    
    predicao = rede(X_teste); % Realizando uma predição

    % Uma acurácia é obtida comparando os testes com a predição
    [~, amostrasDeTeste] = size(Y_teste);

    [~, classePred] = max(predicao);
    [~, classeCerta] = max(Y_teste);

    acertos = classePred == classeCerta;
    acertosEmTeste = sum(acertos);
    acuracia = acertosEmTeste / amostrasDeTeste;   

    somaAcuracia = somaAcuracia + acuracia;

    fprintf('Acurácia da %d° Época: %f\n', epoca, acuracia);
end

fprintf('Média das Acurácias: %f\n: %f\n', (somaAcuracia/10));