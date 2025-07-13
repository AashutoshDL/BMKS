// src/context/LanguageContext.js
import React, { createContext, useState, useContext } from 'react';

const LanguageContext = createContext();

 export const LanguageProvider = ({ children }) => {
  const [language, setLanguage] = useState('en');
  const setLang = (lang) => {
    setLanguage(lang);
  };

  return (
    <LanguageContext.Provider value={{ language, setLang }}>
      {children}
    </LanguageContext.Provider>
  );
};

export const useLanguage = () => {
  return useContext(LanguageContext);
};
