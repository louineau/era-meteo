import React, { useState } from 'react';

const SearchBar = ({ onSearch }) => {
  const [city, setCity] = useState('');

  const handleSearch = () => {
    onSearch(city);
  };

  return (
    <div className="search-bar">
      <input
        type="text"
        value={city}
        onChange={(e) => setCity(e.target.value)}
        placeholder="Entrez le nom de la ville"
      />
      <button onClick={handleSearch}>Rechercher</button>
    </div>
  );
};

export default SearchBar;
