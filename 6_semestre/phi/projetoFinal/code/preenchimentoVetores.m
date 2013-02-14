
% Sinal de tens�o real
v_sinal(i+m) = (((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss;
% Sinal de tens�o real amplificado
v_sinal_amp(i+m) = ((((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
% Sinal de tens�o ideal
v_sinal_ideal(i+m) = (illum_min_ideal*alfa*10^(-6))*rss;
% Sinal de tens�o ideal amplificado
v_sinal_ideal_amp(i+m) = ((illum_min_ideal*alfa*10^(-6))*rss*ganho)-offset;
% Sinal de lumin�ncia real
lux_sinal(i+m)= (illum_min_ideal+tmp)*illum_relative_response;
% Sinal de lumin�ncia amplificado
lux_sinal_ideal(i+m)=illum_min_ideal;