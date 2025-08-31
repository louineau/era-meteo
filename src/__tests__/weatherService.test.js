import { fetchWeatherForecast } from '../services/weatherService';

describe('fetchWeatherForecast (appel réel)', () => {
  test('retourne des données pour Paris', async () => {
    const data = await fetchWeatherForecast('Paris');
    
    // On vérifie que la réponse contient les infos attendues
    expect(data).toHaveProperty('city');
    expect(data.city).toHaveProperty('name', 'Paris');
    expect(Array.isArray(data.list)).toBe(true);
  }, 10000); // timeout 10s car appel externe
});
