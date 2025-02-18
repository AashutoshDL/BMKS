import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import { TITLE_TEXT, NAVBAR_TEXT } from '../services/contentService';
import Hero from '../components/Hero';
import Footer from '../components/Footer';
import Programmes from '../components/Programmes';
import Volunteers from '../components/Volunteers';

const Homepage = () => {
  const { language, setLang } = useLanguage();

  return (
    <div className="p-4 font-['FigTree']">
      <div className="text-black p-4 flex justify-between items-center mb-6 rounded-xl ">
        <div className='flex items-center space-x-4'>
          <img src="/images/logo.png" alt="Logo" className="h-26 w-26 object-contain" />
        <div className="text-3xl font-bold">
          {TITLE_TEXT[language].title}
        </div>
        </div>
        <div className="flex space-x-8">
          <ul className="flex space-x-8">
            <li className="hover:text-black">{NAVBAR_TEXT[language].navElement1}</li>
            <li className="hover:text-black">{NAVBAR_TEXT[language].navElement2}</li>
            <li className="hover:text-black">{NAVBAR_TEXT[language].navElement3}</li>
            <li className="hover:text-black">{NAVBAR_TEXT[language].navElement4}</li>
          </ul>
        </div>
        <div className="relative flex items-center">
          <select
            className="bg-gray-700 text-white px-5 py-2 rounded-lg"
            value={language}
            onChange={(e) => setLang(e.target.value)}
          >
            <option value="en">English</option>
            <option value="hi">हिन्दी</option>
            <option value="ne">नेपाली</option>
          </select>
        </div>
      </div>
          <Hero />
          <Programmes />
          <Volunteers />
          <Footer />
    </div>
  );
};

export default Homepage;
