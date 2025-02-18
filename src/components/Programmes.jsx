import React from 'react';
import InfoCard from './InfoCard'; // Import the InfoCard component
import { CARD_INFO } from '../services/contentService';
import { useLanguage } from '../context/LanguageContext';

const Programmes = () => {
    const {language}=useLanguage();
  return (
    <>
      <div className="text-center mt-16 mb-8 z-10">
        <h1 className="text-4xl font-bold">{CARD_INFO.mainTitle[language]}</h1>
      </div>
      <div className="w-full flex flex-wrap justify-center z-10 pb-15">
        <InfoCard topic="bmks" />
        <InfoCard topic="tree" />
        <InfoCard topic="intoxication" />
        <InfoCard topic="janajagaran" />
      </div>
    </>
  );
};

export default Programmes;
