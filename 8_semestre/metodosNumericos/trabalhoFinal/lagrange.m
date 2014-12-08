function [ p, coeficientes] = lagrange( x_inicial,y_inicial, valor)
%Lagrange - Fun��o de interpola��o usando polin�mio de Lagrange para n
%pontos
%   Fun��o para calcular o resultado do polin�mio de lagrande de grau n
%   para um valor espec�fico. Recebe dois vetores com os valores de x
%   e y dos pontos conhecidos e o valor x que se deseja obter f(x).
n = length(x_inicial);
dif(1,n) = 0;
produto = ones(1,n);
mat_dif(n,n) = 1;
x = valor;
prod_x = 1;
for i=1:n
    %Calcula a diferen�a x - x(i); i=1,2,...,n
    dif(1,i) = x - x_inicial(i);
    % Calcula o valor de Prod_x. O valor � atualizado a cada itera��o
    % levando em conta o pr�ximo valor de x(i).
    prod_x = prod_x*dif(i);
    for j=1:n
        if i==j
            mat_dif(i,j) = 1;
        else
            % Constr�i a matriz com as difere�as entre x(i) - x(j)
            mat_dif(i,j) = x_inicial(i)-x_inicial(j);
        end
        % Usa o resultado da matriz de diferen�as para calcular Prod(i)
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

% Calcula cada termo da solu��o
for i=1:n
    resultado(1,i) = y_inicial(1,i)/(dif(1,i)*produto(1,i));
end

% F�rmula final
p = prod_x*(sum(resultado));

end



