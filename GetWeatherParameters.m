function  [T_a, V_w, Phi] = GetWeatherParameters(idx_weather, weather_parameters)
    T_a = weather_parameters{idx_weather,'T_a'};
    V_w = weather_parameters{idx_weather,'V_w'};
    Phi = weather_parameters{idx_weather,'Phi'};
end