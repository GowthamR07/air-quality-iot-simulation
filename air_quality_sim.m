% air_quality_sim.m
% Simulation-based Smart Air Quality & Pollution Alert System

%% -------------------- USER CONFIG --------------------
WRITE_KEY   = '3TAW50G6GQPMDY5O';
READ_KEY    = '52QAIHXIF3GC6JG5';
CHANNEL_ID  = 3175283;
UPDATE_INTERVAL = 15;
rng('shuffle');

%% -------------------- SIMULATION PARAMETERS --------------------
PM25_MIN = 5;   PM25_MAX = 300;
PM10_MIN = 10;  PM10_MAX = 400;
CO2_MIN  = 350; CO2_MAX  = 5000;

pm25_step = 2.5;
pm10_step = 3.5;
co2_step  = 6;

spike_prob = 0.05;
pm25_spike_range = [20, 45];
pm10_spike_range = [30, 80];
co2_spike_range  = [50, 200];

AQI_ALERT = 150;

%% -------------------- INITIAL VALUES --------------------
pm25 = 35; pm10 = 45; co2 = 450;
aqi_history = nan(1,4);

%% -------------------- MAIN LOOP --------------------
fprintf('Starting Smart Air Quality Simulation. Press Ctrl+C to stop.\n\n');

while true

    %% -------- Phase 2: Safe read previous TS data --------
     
    pause(0.1);



    %% -------- Phase 3: PM2.5 simulation --------
    pm25 = pm25 + randn()*pm25_step;
    if rand < spike_prob
        pm25 = pm25 + (pm25_spike_range(1) + rand*(pm25_spike_range(2)-pm25_spike_range(1)));
    end
    pm25 = clamp(pm25, PM25_MIN, PM25_MAX);

    %% -------- Phase 4: PM10 & CO2 simulation --------
    pm10 = pm10 + 0.4*(pm25 - pm10)*0.1 + randn()*pm10_step;
    if rand < spike_prob
        pm10 = pm10 + (pm10_spike_range(1) + rand*(pm10_spike_range(2)-pm10_spike_range(1)));
    end
    pm10 = clamp(pm10, PM10_MIN, PM10_MAX);

    co2 = co2 + randn()*co2_step + 0.05*(pm25 + pm10)/2;
    if rand < spike_prob*0.6
        co2 = co2 + (co2_spike_range(1) + rand*(co2_spike_range(2)-co2_spike_range(1)));
    end
    co2 = clamp(co2, CO2_MIN, CO2_MAX);

    %% -------- Phase 5: AQI computation --------
    aqi_pm25 = compute_aqi_pm25(pm25);
    aqi_pm10 = compute_aqi_pm10(pm10);
    aqi = max(aqi_pm25, aqi_pm10);

    %% -------- Phase 6: AQI prediction --------
    aqi_history = [aqi_history(2:end) aqi];
    recent = aqi_history(~isnan(aqi_history));

    if isempty(recent)
        predicted_aqi = aqi;
    else
        predicted_aqi = mean(recent);
    end

    %% -------- Phase 7: Alert logic --------
    if aqi > AQI_ALERT
        alert_status = 1;
    else
        alert_status = 0;
    end

    %% -------- Phase 8: Upload to ThingSpeak --------
    try
        dataFields = [pm25, pm10, co2, aqi, alert_status, predicted_aqi, aqi];

        thingSpeakWrite(CHANNEL_ID, dataFields, ...
            'Fields', 1:7, 'WriteKey', WRITE_KEY);

        fprintf('[OK] PM2.5=%.2f | PM10=%.2f | CO2=%.1f | AQI=%.0f | Pred=%.1f | Status=%d\n', ...
            pm25, pm10, co2, aqi, predicted_aqi, alert_status);

    catch writeErr
        fprintf('[ERROR] ThingSpeak write failed: %s\n', writeErr.message);
    end

    pause(UPDATE_INTERVAL);
end   % <<<<<<<< THIS WAS THE MISSING END (NOW FIXED)

%% -------------------- Helper Functions --------------------
function y = clamp(x, lo, hi)
    y = min(max(x, lo), hi);
end

function AQI = compute_aqi_pm25(conc)
    bp = [0,12,35.4,55.4,150.4,250.4,350.4,500.4];
    I  = [0,50,100,150,200,300,400,500];
    AQI = interp_aqi(conc, bp, I);
end

function AQI = compute_aqi_pm10(conc)
    bp = [0,54,154,254,354,424,504,604];
    I  = [0,50,100,150,200,300,400,500];
    AQI = interp_aqi(conc, bp, I);
end

function Iout = interp_aqi(C, BP, I)
    idx = find(BP >= C,1);
    if isempty(idx) || idx == 1
        idx = 2;
    end
    lowC = BP(idx-1); hiC = BP(idx);
    lowI = I(idx-1);  hiI = I(idx);
    Iout = ( (hiI - lowI)/(hiC - lowC) ) * (C - lowC) + lowI;
    Iout = round(Iout);
end
