import React from 'react';
import { motion } from 'framer-motion';
import { Shield, AlertTriangle, Eye, Lock } from 'lucide-react';

const Overview = () => {
  const features = [
    {
      icon: Shield,
      title: 'Comprehensive Protection',
      description: 'Multi-layered security architecture designed specifically for LLM applications with real-time threat analysis.'
    },
    {
      icon: AlertTriangle,
      title: 'Prompt Injection Defense',
      description: 'Advanced detection and prevention of prompt injection attacks using machine learning models.'
    },
    {
      icon: Eye,
      title: 'Real-time Monitoring',
      description: 'Continuous monitoring of LLM interactions with detailed logging and alerting capabilities.'
    },
    {
      icon: Lock,
      title: 'Data Privacy',
      description: 'Built-in PII detection and redaction to ensure sensitive information never leaves your system.'
    }
  ];

  return (
    <section id="overview" className="py-20 px-4 bg-slate-900/30">
      <div className="container mx-auto max-w-6xl">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-4xl md:text-5xl font-bold mb-4 bg-gradient-to-r from-cyan-400 to-blue-500 bg-clip-text text-transparent">
            Overview
          </h2>
          <p className="text-xl text-slate-400 max-w-3xl mx-auto">
            SecureAI Framework is a comprehensive security solution designed to protect your LLM applications from emerging threats while maintaining optimal performance.
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={feature.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              className="p-6 bg-slate-900/50 rounded-xl border border-slate-800 hover:border-cyan-500/50 transition-all duration-300 group"
            >
              <div className="flex items-start gap-4">
                <div className="p-3 bg-cyan-500/10 rounded-lg group-hover:bg-cyan-500/20 transition-colors duration-300">
                  <feature.icon className="w-6 h-6 text-cyan-400" />
                </div>
                <div>
                  <h3 className="text-xl font-semibold mb-2 text-slate-100">{feature.title}</h3>
                  <p className="text-slate-400">{feature.description}</p>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Overview;