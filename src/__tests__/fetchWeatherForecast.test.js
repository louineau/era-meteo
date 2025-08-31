import { fetchWeatherForecast } from '../services/weatherService';
import axios from 'axios';

jest.mock('axios');

describe('fetchWeatherForecast - vérification des params', () => {
  test('appelle axios avec la bonne URL et params', async () => {
    axios.get.mockResolvedValue({ data: { city: { name: 'Paris' }, list: [] } });

    await fetchWeatherForecast('Paris');

    expect(axios.get).toHaveBeenCalledWith(
      expect.stringContaining('forecast'),
      expect.objectContaining({
        params: expect.objectContaining({
          q: 'Paris',
          units: 'metric',
          lang: 'fr',
        }),
      })
    );
  });
});
