import React, { useState, useEffect } from 'react';

const Hero = () => {
  const [currentSlide, setCurrentSlide] = useState(0);
  const images = [
    "/images/dashboardImage1.jpg",
    "/images/dashboardImage2.jpg",
    "/images/dashboardImage3.jpg",
    "/images/dashboardImage4.jpg",
    "/images/dashboardImage5.jpg",
  ];

  // Automatically change slide every 3 seconds
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentSlide((prevSlide) => (prevSlide + 1) % images.length);
    }, 3000); // Change every 3 seconds

    return () => clearInterval(interval); // Cleanup interval on component unmount
  }, []);

  return (
    <div className="bg-[#FF6E43] text-white p-0 h-screen flex items-center justify-center flex-col relative overflow-hidden">

      {/* Image Carousel - Background with Fade Animation */}
      <div className="absolute top-0 left-0 w-full h-full z-0">
        <div
          className="w-full h-full transition-all duration-1500 ease-in-out"
          style={{
            backgroundImage: `url(${images[currentSlide]})`,
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            backgroundRepeat: 'no-repeat',
            opacity: 1,
          }}
        />
      </div>
    </div>
  );
};

export default Hero;