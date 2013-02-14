
% Sinal de tensão real
v_sinal(i+m) = (((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss;
% Sinal de tensão real amplificado
v_sinal_amp(i+m) = ((((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
% Sinal de tensão ideal
v_sinal_ideal(i+m) = (illum_min_ideal*alfa*10^(-6))*rss;
% Sinal de tensão ideal amplificado
v_sinal_ideal_amp(i+m) = ((illum_min_ideal*alfa*10^(-6))*rss*ganho)-offset;
% Sinal de luminância real
lux_sinal(i+m)= (illum_min_ideal+tmp)*illum_relative_response;
% Sinal de luminância amplificado
lux_sinal_ideal(i+m)=illum_min_ideal;