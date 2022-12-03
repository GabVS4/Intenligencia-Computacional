%% Declaração da Matriz
mat =[0 1 2 4 6 2 2 3 3 5 6 1 4 5;
    1 0 3 2 1 3 6 3 4 4 2 4 4 4;
    2 3 0 1 3 3 2 3 4 1 3 5 5 6;
    4 2 1 0 5 1 4 2 3 4 4 8 2 2;
    6 1 3 5 0 2 1 6 5 2 3 4 2 2;
    2 3 3 1 2 0 3 1 2 3 5 7 3 4;
    2 6 2 4 1 3 0 2 1 2 5 2 4 3;
    3 3 3 2 6 1 2 0 5 5 1 5 3 6;
    3 4 4 3 5 2 1 5 0 1 4 4 5 3;
    5 4 1 4 2 3 2 5 1 0 5 4 4 2;
    6 2 3 4 3 5 5 1 4 5 0 4 2 1;
    1 4 5 8 4 7 2 5 4 4 4 0 1 3;
    4 4 5 2 2 3 4 3 5 4 2 1 0 1;
    5 4 6 2 2 4 3 6 3 2 1 3 1 0;];

%% Gerando uma população aleatória
populacao = zeros(100,height(mat));

for l = 1 : 100
    populacao(l,:) = randperm(14);
end

%% Gerando 100 gerações
T = 0;
melhorCaminho = zeros(100,14); %Armazena os melhores caminhos de cada gen
melhorCaminhoPeso = zeros(100,1); %Armazena os pesos dos melhores caminhos de cada gen

while T <= 99
    peso = zeros(1, 100);
    pais = zeros(100, 14);
    novaGen = zeros(100, 14);

    for i=1:height(populacao)
        peso(i) = somaDistancia(populacao(i, :),mat); %Gera o peso(soma das distancias) dos indivíduos
        paiId = selecao(populacao, mat); %Seleciona a população de individuos
        pais(i,:) = populacao(paiId,:);
    end
    [AvaliacaoMelhorIndividuo, IdMelhorIndividuo] = max(peso); %Pega a nota e o indice do melhor indivíduo da geração

    for i=1:2:height(populacao) %Realiza o cruzamento(mapeamento pacial) da geração
        [f1, f2] = cruzamento(pais(i,:),pais(i+1,:));
        novaGen(i,:) = f1;
        novaGen(i+1,:) = f2;
    end

    for i=1:height(populacao) %Passa os indivíduos por uma possível mutação
        novaGen(i,:) = mutacao(novaGen(i,:));
    end
    
    populacao = novaGen;
    T = T + 1;

    melhorCaminho(i,:) = populacao(IdMelhorIndividuo,:); %Guardando os melhores indivíduos das gerações
    melhorCaminhoPeso(i,:) = AvaliacaoMelhorIndividuo; %%Guardando as notas dos melhores indivíduos das gerações

    %Mostragem dos melhores indivíduos e suas notas a cada geração
    fprintf("Geracao: %d \n",T);
    fprintf("Melhor individuo: %d com peso: %f\n",IdMelhorIndividuo,AvaliacaoMelhorIndividuo);
end

%% Mostragem do melhor Caminho
[~, melhorId] = max(melhorCaminhoPeso);
fprintf("Melhor caminho:\n");
melhorCaminho(melhorId,:)
fprintf("Distancia percorrida caminho: %d \n", max(1/AvaliacaoMelhorIndividuo));

%% Funções
%Gera um número aleatório no intervalo dado
function numeroRand = numeroAleatorio(a, b)
    numeroRand = floor(rand(1, 1) .* (b - a) + a);
end

%Função de mapeamento parcial
function [filho1, filho2] = cruzamento(pai1, pai2)
        paiAux1 = pai1;
        paiAux2 = pai2;

        mapeamento = zeros(1, length(pai1));

        %Gerando os pontos de corte
        pontoCorte_1 = numeroAleatorio(1, length(mapeamento) - 1);
        aux = numeroAleatorio(1, length(mapeamento) - pontoCorte_1 - 1);
        pontoCorte_2 = pontoCorte_1 + aux;

        for i = pontoCorte_1 : pontoCorte_2
            mapeamento(pai1(i)) = pai2(i);
            mapeamento(pai2(i)) = pai1(i);
        end

        %Gera o filho 1 a partir da subistituição dos cortes no pai 1
        for i = 1:length(pai1)
            if (mapeamento(paiAux1(i)) ~= 0)
                aux1 = mapeamento(paiAux1(i));
                if (mapeamento(aux1) == paiAux1(i))
                    paiAux1(i) = mapeamento(paiAux1(i));
                end
            end
        end

        %Gera o filho 2 a partir da subistituição dos cortes no pai 2
        for i = 1:length(pai2)
            if (mapeamento(paiAux2(i)) ~= 0)
                aux2 = mapeamento(paiAux2(i));
                if (mapeamento(aux2) == paiAux2(i))
                    paiAux2(i) = mapeamento(paiAux2(i));
                end
            end
        end

        filho1 = paiAux1;
        filho2 = paiAux2;
end

%Gera uma mutação em 0.5% dos casos
function [array] = mutacao(array)
    chanceMut = numeroAleatorio(1, 1000);
    if (chanceMut <= 5)
        posicao_1 = numeroAleatorio(1, length(array));
        posicao_2 = numeroAleatorio(1, length(array));
        aux = array(posicao_1);
        array(posicao_1) = array(posicao_2);
        array(posicao_2) = aux;
    end
end

%Função para retornar a soma dos caminhos
function [peso] = somaDistancia(array, matriz)
    aux = 0;
    for i=1:1:(length(array)-1) %Soma dos caminhos da posição 1 até a 14
       distancia = matriz(array(i), array(i+1));
       aux = aux + distancia;
    end
    soma = aux + matriz(array(end), array(1)); %Soma dos caminhos da posição 14 com a posição 1
    peso = 1/soma;
end

%Função de seleção dos novos indivídos
function index = selecao(populacao, matriz)
    soma = ones(1,100);
    for i=1:height(populacao)
        soma(i) = somaDistancia(populacao(i,:), matriz);
    end
    s = numeroAleatorio(1, sum(soma));
    aux = somaDistancia(populacao(1, :), matriz);
    i = 1;
    while aux < s
        i = i + 1;
        aux = aux + somaDistancia(populacao(i, :),matriz);
    end
    index = i;
end