D =[122 139 0.115;
114 126 0.120;
086 090 0.105;
134 144 0.090;
146 163 0.100;
107 136 0.120;
068 061 0.105;
117 062 0.080;
071 041 0.100;
098 120 0.115];

x1 = D(:, 1); %Variável regressora
x2 = D(:, 2); %Variável regressora
y = D(:,3); %Variável dependente

%Matriz de entrada X:
x = [ones(10,1), x1, x2];

beta = ((x' * x)^-1) * x' * y;

%Mostrando o Gráfico:
plot3 (x1, x2, y, '*');
grid on;
hold on;
[x_1, x_2] = meshgrid (30:0.5:180, 30:0.5:180);
Y = beta(1) + beta(2) * x_1 + beta(3) * x_2;
mesh(x_1, x_2, Y);

predicao = x * beta; %Nova predição

%Calculo do R2:
R2 = 1 - (sum((y - predicao).^2)) / (sum((y - mean(y)).^2));
fprintf('R2 = %f\n', R2);
