% Pegando os valores do Input
Temperatura = sprintf('Insira a Temperatura');
temperatura = inputdlg('Insira a temperatura', Temperatura);

Preco = sprintf('Insira o Unitário');
preco = inputdlg('Insira o Unitário', Preco);

temperatura = str2double(temperatura);
preco = str2double(preco);

% Definindo Variáveis
rangeTemperatura = [15 45];
rangePrecoUnitario = [1 6];
rangeConsumo = [500 6000];

% Entrada 1 - Temperatura
temperaturaBaixa = functionBuilder(temperatura, [6.369, 15], 'gaussmf');
temperaturaMedia = functionBuilder(temperatura, [6.369, 30], 'gaussmf');
temperaturaAlta = functionBuilder(temperatura, [6.369, 45], 'gaussmf');

% Entrada 2 - Preço
precoBaixo = functionBuilder(preco, [1.061, 1], 'gaussmf');
precoMedio = functionBuilder(preco, [1.061, 3.05], 'gaussmf');
precoAlto = functionBuilder(preco, [1.061, 6], 'gaussmf');

% Saída - Consumo
consumoPequeno = functionBuilder(rangeConsumo, [-2250, 500, 3250], 'trimf');
consumoMedio = functionBuilder(rangeConsumo, [500, 3250, 6000], 'trimf');
consumoGrande = functionBuilder(rangeConsumo, [3250, 6000, 8750], 'trimf');

%Regras de Negócio
regra1 = prod([temperaturaBaixa, precoBaixo]);
regra2 = prod([temperaturaBaixa, precoMedio]);
regra3 = prod([temperaturaBaixa, precoAlto]);
regra4 = prod([temperaturaMedia, precoBaixo]);
regra5 = prod([temperaturaMedia, precoMedio]);
regra6 = prod([temperaturaMedia, precoAlto]);
regra7 = prod([temperaturaBaixa, precoBaixo]);
regra8 = prod([temperaturaBaixa, precoMedio]);
regra9 = prod([temperaturaBaixa, precoAlto]);

%Implicação das Regras de Negócio
consumo_pequeno = prod([regra3, regra6, regra9]);
consumo_medio = prod([regra2, regra5, regra8]);
consumo_grande = prod([regra1, regra4, regra7]);

%Agregação das Implicações
baixoPertecimentoConsumo = min(consumoPequeno, consumo_pequeno);
medioPertecimentoConsumo = min(consumoMedio, consumo_medio);
altoPertecimentoConsumo = min(consumoGrande, consumo_grande);

agregacao = max(baixoPertecimentoConsumo, medioPertecimentoConsumo);
agregacao = max(agregacao, altoPertecimentoConsumo);

%Centroide
centroide = sum(agregacao .* rangeConsumo) / sum(agregacao)

function saida = functionBuilder(valor, range, tipo)
    switch tipo
        case 'gaussmf'
            saida = gaussmf(valor, range);
        case 'trimf'
            saida = trimf(valor, range);
    end
end





