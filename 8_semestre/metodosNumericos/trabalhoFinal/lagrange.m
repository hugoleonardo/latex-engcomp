function [ p, coeficientes] = lagrange( x_inicial,y_inicial, valor)
%Lagrange - Função de interpolação usando polinômio de Lagrange para n
%pontos
%   Função para calcular o resultado do polinômio de lagrande de grau n
%   para um valor específico. Recebe dois vetores com os valores de x
%   e y dos pontos conhecidos e o valor x que se deseja obter f(x).
n = length(x_inicial);
dif(1,n) = 0;
produto = ones(1,n);
mat_dif(n,n) = 1;
x = valor;
prod_x = 1;
for i=1:n
    %Calcula a diferença x - x(i); i=1,2,...,n
    dif(1,i) = x - x_inicial(i);
    % Calcula o valor de Prod_x. O valor é atualizado a cada iteração
    % levando em conta o próximo valor de x(i).
    prod_x = prod_x*dif(i);
    for j=1:n
        if i==j
            mat_dif(i,j) = 1;
        else
            % Constrói a matriz com as difereças entre x(i) - x(j)
            mat_dif(i,j) = x_inicial(i)-x_inicial(j);
        end
        % Usa o resultado da matriz de diferenças para calcular Prod(i)
        produto(1,i) = produto(1,i)*mat_dif(i,j);
    end
end

%mat_dif(find(eye(3))) = [1 1 1];
resultado = zeros(1,n);
coeficientes = ones(1,n);

for i=1:n
    for j=1:n
        if i==j
            
        else
        coeficientes(1,i) = coeficientes(1,i)*((x-x_inicial(j)));
        end
    end
        coeficientes(1,i) = y_inicial(i)*coeficientes(1,i)/produto(1,i);
end

% Calcula cada termo da solução
for i=1:n
    resultado(1,i) = y_inicial(1,i)/(dif(1,i)*produto(1,i));
end

% Fórmula final
p = prod_x*(sum(resultado));

end



