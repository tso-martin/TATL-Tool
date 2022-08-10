function [I_prefault] = GetPreFaultCurrent(idx_line, idx_weather, preloading, conductor_parameters, weather_parameters)
    I_prefault = preloading * weather_parameters{idx_weather,'PATL'}/100 * conductor_parameters{idx_line, 'I_r'};
end