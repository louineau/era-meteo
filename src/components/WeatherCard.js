import React from 'react';

const WeatherCard = ({ weatherData, selectedDay, onDayClick }) => {
  // Regrouper les données par jour
  const dailyForecast = weatherData.list.reduce((acc, item) => {
    const date = item.dt_txt.split(' ')[0];
    if (!acc[date]) {
      acc[date] = {
        minTemp: item.main.temp_min,
        maxTemp: item.main.temp_max,
        conditions: item.weather[0].description,
        icon: item.weather[0].icon,
        hourly: [],
      };
    }
    acc[date].hourly.push(item);
    acc[date].minTemp = Math.min(acc[date].minTemp, item.main.temp_min);
    acc[date].maxTemp = Math.max(acc[date].maxTemp, item.main.temp_max);
    return acc;
  }, {});

  return (
    <div className="weather-container">
      {Object.keys(dailyForecast).map((date, index) => (
        <div key={index} className="weather-item" onClick={() => onDayClick(date)}>
          <p>{new Date(date).toLocaleDateString('fr-FR', { weekday: 'long' })}</p>
          <p>Température: {dailyForecast[date].maxTemp.toFixed(2)}°C</p>
          <p>Conditions: {dailyForecast[date].conditions}</p>
          <img
            src={`https://openweathermap.org/img/wn/${dailyForecast[date].icon}@2x.png`}
            alt={dailyForecast[date].conditions}
          />
          {selectedDay === date && (
            <div className="hourly-details">
              {dailyForecast[date].hourly.map((hour, idx) => (
                <div key={idx} className="hourly-item">
                  <p>{new Date(hour.dt_txt).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}</p>
                  <p>Température: {hour.main.temp}°C</p>
                  <p>Conditions: {hour.weather[0].description}</p>
                  <img
                    src={`https://openweathermap.org/img/wn/${hour.weather[0].icon}@2x.png`}
                    alt={hour.weather[0].description}
                  />
                </div>
              ))}
            </div>
          )}
        </div>
      ))}
    </div>
  );
};

export default WeatherCard;
