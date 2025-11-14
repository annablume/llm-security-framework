import React from 'react';
import { Helmet } from 'react-helmet';
import Header from '@/components/Header';
import Hero from '@/components/Hero';
import Overview from '@/components/Overview';
import Features from '@/components/Features';
import Quickstart from '@/components/Quickstart';
import Installation from '@/components/Installation';
import UsageExamples from '@/components/UsageExamples';
import Footer from '@/components/Footer';
import { Toaster } from '@/components/ui/toaster';

function App() {
  return (
    <>
      <Helmet>
        <title>SecureAI Framework - LLM Security Documentation</title>
        <meta name="description" content="Comprehensive documentation for SecureAI Framework - A robust security framework for Large Language Models with advanced threat detection and protection." />
      </Helmet>
      <div className="min-h-screen bg-slate-950 text-slate-100">
        <Header />
        <main>
          <Hero />
          <Overview />
          <Features />
          <Quickstart />
          <Installation />
          <UsageExamples />
        </main>
        <Footer />
        <Toaster />
      </div>
    </>
  );
}

export default App;