import React from 'react';
import { VOLUNTEERS_CONTENT } from '../services/contentService'; // Adjust the import path
import { useLanguage } from '../context/LanguageContext';

const VolunteerCard = ({ image, name, post, phone, email }) => {
  return (
    <div className="w-64 flex flex-col items-center justify-center bg-white shadow-lg rounded-lg p-4">
      {/* Circle Container */}
      <div className="w-64 h-64 rounded-full overflow-hidden mb-4">
        {/* Image */}
        <img src={image} alt={name} className="w-full h-full object-cover" />
      </div>
      
      {/* Card Body - Info displayed below the circle */}
      <div className="flex flex-col items-center text-center space-y-2 text-black">
        {/* Name */}
        <h2 className="text-xl font-bold">{name}</h2>
        
        {/* Post */}
        <p className="text-sm">{post}</p>
        
        {/* Phone Number */}
        <p className="text-sm">Phone: <a href={`tel:${phone}`} className="text-blue-500">{phone}</a></p>
        
        {/* Email */}
        <p className="text-sm">Email: <a href={`mailto:${email}`} className="text-blue-500">{email}</a></p>
      </div>
    </div>
  );
};

const Volunteers = () => {
    const {language}=useLanguage();

  const volunteers = [
    {
      image: '/images/volunteer1.JPG',
      name: VOLUNTEERS_CONTENT.volunteer1.name[language],
      post: VOLUNTEERS_CONTENT.volunteer1.post[language],
      phone: VOLUNTEERS_CONTENT.volunteer1.phone,
      email: VOLUNTEERS_CONTENT.volunteer1.email,
    },
    {
      image: '/images/volunteer1.JPG',
      name: VOLUNTEERS_CONTENT.volunteer2.name[language],
      post: VOLUNTEERS_CONTENT.volunteer2.post[language],
      phone: VOLUNTEERS_CONTENT.volunteer2.phone,
      email: VOLUNTEERS_CONTENT.volunteer2.email,
    },
  ];

  return (
    <div className="flex flex-wrap justify-center gap-4 p-4">
      {volunteers.map((volunteer, index) => (
        <VolunteerCard
          key={index}
          image={volunteer.image}
          name={volunteer.name}
          post={volunteer.post}
          phone={volunteer.phone}
          email={volunteer.email}
        />
      ))}
    </div>
  );
};

export default Volunteers;
