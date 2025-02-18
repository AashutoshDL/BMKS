import React from 'react';
import { FOOTER_CONTENT } from '../services/contentService'; // Import content

const Footer = () => {
  return (
    <div className="bg-gray-800 text-white">
      {/* Full-width Footer Banner Image */}
      <img src="/images/footerBanner.jpg" alt="Footer Banner" className="w-screen h-auto object-cover" />

      {/* Social Media Links - Centered Below Image */}
      <div className="text-center space-x-6">
        <a href={FOOTER_CONTENT.socialLinks.facebook} target="_blank" rel="noopener noreferrer" className="hover:text-blue-600">
          Facebook
        </a>
        <a href={FOOTER_CONTENT.socialLinks.instagram} target="_blank" rel="noopener noreferrer" className="hover:text-pink-600">
          Instagram
        </a>
        <a href={FOOTER_CONTENT.socialLinks.twitter} target="_blank" rel="https://www.facebook.com/bmksnepalofficial" className="hover:text-blue-400">
          Twitter
        </a>
      </div>
    </div>
  );
};

export default Footer;
