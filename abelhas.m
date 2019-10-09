f = @(x, y) 100*(y - x^2)^2 + (1 - x)^2;

% Limites da funcao
limite_x = 3;
limite_y = -3;

% Precisao minima do resultado
tolerancia = 0.01;

% Numero de abelhas de cada tipo
% As abelhas operarias voam para locais ao redor da colmeia (inicialmente aleatorio).
% As abelhas seguidoras tem como referencia a informacao trazida pelas abelhas operarias.
% As abelhas exploradoras voam aleatoriamente, explorando lugares distindos.
operarias = 10;
seguidoras = 10;
exploradoras = 10;

% Maxima distancia ao redor de um ponto que uma abelha explora
passo = 0.1;

pos_operarias = [];
pos_seguidoras = [];
pos_exploradoras = [];

pos_total = [];

% Coloca a posicao inicial das abelhas operarias,
% a primeiras posicoes sao aleatorias
for a=1 : operarias 
  pos_operarias(a,1) = limite_y + rand()*(limite_x - limite_y);
  pos_operarias(a,2) = limite_y + rand()*(limite_x - limite_y);
  pos_total(a,1) = pos_operarias(a,1);
  pos_total(a,2) = pos_operarias(a,2);
end

% Plota o grafico da funcao
X = linspace(-limite_x,limite_x,100);
Y = linspace(-limite_y,limite_y,100);
fig = figure();

[xplot, yplot] = meshgrid(X,Y);

zplot = 100*(yplot - xplot.^2).^2 + (1 - xplot).^2;

surf(xplot, yplot, zplot);
shading interp;

hold on;

% Plota a distribuicao inicial das abelhas operarias
for i=1:operarias  
  scatter3(pos_operarias(i,1), pos_operarias(i,2), f(pos_operarias(i,1), pos_operarias(i,2)),25,1);
end
  
hold on;

% Coloca a posicao inicial das abelhas exploradoras,
% sempre aleatorio
for b=1 : exploradoras
  pos_exploradoras(b,1) = limite_y + rand()*(limite_x - limite_y);
  pos_exploradoras(b,2) = limite_y + rand()*(limite_x - limite_y);
  pos_total(b+operarias,1) = pos_exploradoras(b,1);
  pos_total(b+operarias,2) = pos_exploradoras(b,2);
end

cont = 0;
melhor = [1,1];
interacoes = 0;

while 1
  interacoes = interacoes + 1;
  cont = cont + 1;

  % Cria o vetor de probabilidades dos pontos
  prob = [];
  
  soma = 0;
  for i=1:length(pos_total);
    soma = soma + f(pos_total(i,1), pos_total(i,2));
  end

  for i=1:length(pos_total);
    last_value = length(prob) + 1;
    value = length(prob) + 1 + ceil((f(pos_total(i,1), pos_total(i,2))/soma)*100);
    for j=last_value : value;
      prob(j) = i;
    end
  end

  % Move as abelhas seguidoras
  for a=1:seguidoras
    % Escolhe um ponto baseado no vetor de probabilidaes  
    index = prob(randi(length(prob), 1));
    ponto = pos_total(index, :);
    
    % O novo ponto estara a um "passo" e distancia do oultro, em um angulo theta aleatorio
    theta = rand()*6.2831;
    pos_seguidoras(a,1) = ponto(1) + cos(theta)*passo;
    if pos_seguidoras(a,1) > limite_x
      pos_seguidoras(a,1) = limite_x;
    elseif pos_seguidoras(a,1) < -limite_x
      pos_seguidoras(a,1) = -limite_x;
    end
    
    pos_seguidoras(a,2) = ponto(2) + sin(theta)*passo;
    if pos_seguidoras(a,2) > limite_y
      pos_seguidoras(a,2) = limite_y;
    elseif pos_seguidoras(a,2) < -limite_y
      pos_seguidoras(a,2) = -limite_y;
    end
    
    pos_total(a+exploradoras+operarias,1) = pos_seguidoras(a,1);
    pos_total(a+exploradoras+operarias,2) = pos_seguidoras(a,2);
  end
  
  % Move as abelhas exploradoras
  for b=1 : exploradoras
    pos_exploradoras(b,1) = limite_y + rand()*(limite_x - limite_y);
    pos_exploradoras(b,2) = limite_y + rand()*(limite_x - limite_y);
    pos_total(b+operarias,1) = pos_exploradoras(b,1);
    pos_total(b+operarias,2) = pos_exploradoras(b,2);
  end

  
  
  % Move as abelhas operarias
  % Cria o vetor de probabilidades dos pontos
  prob = [];
  
  soma = 0;
  for i=1:length(pos_total);
    soma = soma + f(pos_total(i,1), pos_total(i,2));
  end

  for i=1:length(pos_total);
    last_value = length(prob) + 1;
    value = length(prob) + 1 + ceil((f(pos_total(i,1), pos_total(i,2))/soma)*100);
    for j=last_value : value;
      prob(j) = i;
    end
  end
  
  for a=1:seguidoras
    % Escolhe um ponto baseado no vetor de probabilidaes  
    index = prob(randi(length(prob), 1));
    ponto = pos_total(index, :);
    
    % O novo ponto estara a um "passo" e distancia do oultro, em um angulo theta aleatorio
    theta = rand()*6.2831;
    pos_operarias(a,1) = ponto(1) + cos(theta)*passo;
    if pos_operarias(a,1) > limite_x
      pos_operarias(a,1) = limite_x;
    elseif pos_operarias(a,1) < -limite_x
      pos_operarias(a,1) = -limite_x;
    end
    
    pos_operarias(a,2) = ponto(2) + sin(theta)*passo;
    if pos_operarias(a,2) > limite_y
      pos_operarias(a,2) = limite_y;
    elseif pos_operarias(a,2) < -limite_y
      pos_operarias(a,2) = -limite_y;
    end
    pos_total(a,1) = pos_operarias(a,1);
    pos_total(a,2) = pos_operarias(a,2);
  end
  
  % ve o melor ponto
  for i=1 : length(pos_total)
    if f(pos_total(i,1), pos_total(i,2)) > f(melhor(1), melhor(2))
      melhor = pos_total(i, :);
    end  
  end
  % Condicao de parada 
  if cont > 100
    break;    
  end
  
end

% Plot final
scatter3(melhor(1), melhor(2), f(melhor(1), melhor(2)), 75, 3);

disp("interações:")
disp(cont)
disp("melhor ponto: ")
disp(melhor)

