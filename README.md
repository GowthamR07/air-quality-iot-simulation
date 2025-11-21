% IMPORTANT: set WRITE_KEY, READ_KEY and CHANNEL_ID before running.

# Smart Air Quality and Pollution Alert System
A simulation-based IoT project that models air pollution levels and uploads real-time data to the ThingSpeak cloud using MATLAB. The system generates realistic PM2.5, PM10, and CO₂ values, calculates the Air Quality Index (AQI), predicts future AQI trends, and triggers automated alerts when pollution exceeds safe thresholds.

---

## 🚀 Project Overview
Air pollution is increasing worldwide, making real-time monitoring extremely important for public health and environmental safety.  
This project demonstrates how IoT, cloud platforms, and MATLAB-based analytics can be combined to build a **Smart Air Quality Monitoring System**.

The system simulates sensor behavior using a dynamic random-walk model and performs:

- Real-time pollution simulation  
- AQI computation using EPA standards  
- Predictive AQI estimation  
- Pollution alert generation  
- Cloud upload to ThingSpeak for visualization  

The project showcases how IoT-based monitoring solutions can help in smart cities, health monitoring, and environmental protection.

---

## 🧠 Features
- PM2.5, PM10, and CO₂ simulation (random-walk + spikes)
- AQI calculation (PM2.5/PM10 EPA breakpoints)
- Predictive AQI estimation using sliding-window average
- Pollution alert logic (0 = Normal, 1 = High Pollution)
- ThingSpeak cloud integration
- Real-time graph visualization
- Fully compatible with MATLAB Online

---

## 🛠️ Technologies Used
- **MATLAB / MATLAB Online**
- **ThingSpeak IoT Cloud**
- **EPA AQI Breakpoint Algorithm**
- **IoT Data Streams**
- **Simulated Sensors**

---

## 📊 ThingSpeak Channel Fields
| Field | Parameter           |
|-------|----------------------|
| 1     | PM2.5 (µg/m³)        |
| 2     | PM10 (µg/m³)         |
| 3     | CO₂ (ppm)            |
| 4     | AQI                  |
| 5     | Alert Status (0/1)   |
| 6     | Predicted AQI        |
| 7     | Duplicate AQI value  |

---

## 📡 How It Works
1. MATLAB script simulates pollution values.
2. AQI is computed using US EPA standards.
3. Prediction logic estimates next AQI value.
4. Alerts are triggered based on AQI threshold.
5. Data uploads to ThingSpeak every 15 seconds.
6. ThingSpeak dashboard displays graphs in real time.

---

## ▶️ Running the Project
1. Open **MATLAB Online**
2. Upload the file:  
   `air_quality_sim.m`
3. Edit your **Write API Key**, **Read API Key**, and **Channel ID**.
4. Click **Run**.
5. Watch real-time data update on ThingSpeak.

---

## 📁 Files Included
- `air_quality_sim.m` – Main simulation and cloud upload script
- `README.md` – Project documentation

---

## 📌 Future Improvements
- Add real sensor integration (PM, CO₂ modules)
- Use machine learning models for advanced prediction
- Add mobile app notifications for alerts
- Multi-location air quality dashboard

---

## 📝 License
This project is released under the **MIT License**.

---
## HOW IT WORKS
ThingSpeak Channel: https://thingspeak.com/channels/3175283
----------------
## NOTE
NOTE: Do not commit your Write/Read API keys to this repo. Replace keys in the script before running.
--------------

## 👤 Author
Created by (GOWTHAM R)  
Based on MATLAB, IoT, and environmental data simulation concepts.
