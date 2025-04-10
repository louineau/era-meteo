import axios from 'axios';

const API_KEY = '3fb9d0e41d7ea130a6365587279d4200';
const FORECAST_URL = 'https://api.openweathermap.org/data/2.5/forecast';

export const fetchWeatherForecast = async (city) => {
  try {
    const response = await axios.get(FORECAST_URL, {
      params: {
        q: city,
        appid: API_KEY,
        units: 'metric',
        lang: 'fr',
      },
    });
    return response.data;
  } catch (error) {
    console.error('Erreur lors de la récupération des données météo:', error);
    throw error;
  }
};
