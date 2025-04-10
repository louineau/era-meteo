import React, { useState } from 'react';
import SearchBar from './components/SearchBar';
import WeatherCard from './components/WeatherCard';
import { fetchWeatherForecast } from './services/weatherService';
import './App.css';

const App = () => {
  const [weatherData, setWeatherData] = useState(null);
  const [selectedDay, setSelectedDay] = useState(null);
  const [isDarkMode, setIsDarkMode] = useState(false);

  const handleSearch = async (city) => {
    try {
      const data = await fetchWeatherForecast(city);
      setWeatherData(data);
      setSelectedDay(null); // Réinitialiser le jour sélectionné lors d'une nouvelle recherche
    } catch (error) {
      console.error('Erreur lors de la recherche:', error);
    }
  };

  const toggleTheme = () => {
    setIsDarkMode(!isDarkMode);
  };

  return (
    <div className={`App ${isDarkMode ? 'dark-mode' : 'light-mode'}`}>
      <header>
        <h1>Era Météo</h1>
        <button className="theme-toggle" onClick={toggleTheme}>
          {isDarkMode ? 'Passer en mode clair' : 'Passer en mode sombre'}
        </button>
      </header>
      <SearchBar onSearch={handleSearch} />
      {weatherData && (
        <WeatherCard
          weatherData={weatherData}
          selectedDay={selectedDay}
          onDayClick={setSelectedDay}
        />
      )}
    </div>
  );
};

export default App;
