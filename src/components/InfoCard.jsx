import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import { CARD_INFO } from '../services/contentService';

const InfoCard = ({ topic }) => {
  const { language } = useLanguage();
  const cardData = CARD_INFO[topic];

  if (!cardData) {
    return (
      <div className="bg-gray-100 rounded-lg p-4 max-w-md mx-auto my-4">
        Loading...
      </div>
    );
  }

  const { image, title, description } = cardData;

  return (
    <div className="bg-white rounded-xl shadow-lg overflow-hidden max-w-md mx-auto my-4 hover:shadow-xl transition-shadow duration-300">
      <div className="relative w-full h-56">
        <img
          src={image}
          alt={title[language]}
          className="w-full h-full object-cover transition-transform duration-500 hover:scale-105"
        />
      </div>
      
      <div className="p-8 space-y-6">
        <h2 className="text-2xl font-bold text-gray-800 hover:text-blue-600 transition-colors duration-200">
          {title[language]}
        </h2>
        
        <p className="text-lg text-gray-600 leading-relaxed">
          {description[language].length > 200
            ? `${description[language].slice(0, 200)}...`
            : description[language]}
        </p>
        
        {description[language].length > 200 && (
          <a 
            href="#" 
            className="inline-block text-blue-500 hover:text-blue-700 font-medium underline-offset-4 hover:underline"
          >
            Read More
          </a>
        )}
      </div>
    </div>
  );
};

export default InfoCard;