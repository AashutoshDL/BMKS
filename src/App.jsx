import React from 'react';
import Homepage from './containers/Homepage';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { LanguageProvider } from './context/LanguageContext';

const App = () => {
  return (
    <LanguageProvider>
      <Router>
        <div className="min-h-screen m-0 p-0">
          {/* Apply Tailwind utility classes to your container */}
          <Routes>
            <Route path='/' element={<Homepage />} />
          </Routes>
        </div>
      </Router>
    </LanguageProvider>
  );
};

export default App;
