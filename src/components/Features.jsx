import React from 'react';
import { motion } from 'framer-motion';
import { Shield, Zap, Database, Code, Activity, Lock } from 'lucide-react';

const Features = () => {
  const features = [
    {
      icon: Shield,
      title: 'Advanced Threat Detection',
      description: 'ML-powered detection of prompt injections, jailbreaks, and adversarial attacks',
      color: 'cyan'
    },
    {
      icon: Zap,
      title: 'High Performance',
      description: 'Minimal latency overhead with optimized processing pipeline',
      color: 'blue'
    },
    {
      icon: Database,
      title: 'Audit Logging',
      description: 'Comprehensive logging of all LLM interactions for compliance and analysis',
      color: 'purple'
    },
    {
      icon: Code,
      title: 'Easy Integration',
      description: 'Simple API with support for popular LLM frameworks and platforms',
      color: 'cyan'
    },
    {
      icon: Activity,
      title: 'Real-time Analytics',
      description: 'Dashboard with metrics, alerts, and security insights',
      color: 'blue'
    },
    {
      icon: Lock,
      title: 'PII Protection',
      description: 'Automatic detection and redaction of sensitive personal information',
      color: 'purple'
    }
  ];

  const getColorClasses = (color) => {
    const colors = {
      cyan: 'bg-cyan-500/10 border-cyan-500/20 text-cyan-400 group-hover:bg-cyan-500/20',
      blue: 'bg-blue-500/10 border-blue-500/20 text-blue-400 group-hover:bg-blue-500/20',
      purple: 'bg-purple-500/10 border-purple-500/20 text-purple-400 group-hover:bg-purple-500/20'
    };
    return colors[color];
  };

  return (
    <section id="features" className="py-20 px-4">
      <div className="container mx-auto max-w-6xl">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-4xl md:text-5xl font-bold mb-4 bg-gradient-to-r from-cyan-400 to-blue-500 bg-clip-text text-transparent">
            Key Features
          </h2>
          <p className="text-xl text-slate-400 max-w-3xl mx-auto">
            Everything you need to secure your LLM applications in production
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((feature, index) => (
            <motion.div
              key={feature.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              className="p-6 bg-slate-900/50 rounded-xl border border-slate-800 hover:border-cyan-500/50 transition-all duration-300 group"
            >
              <div className={`inline-flex p-3 rounded-lg border mb-4 transition-all duration-300 ${getColorClasses(feature.color)}`}>
                <feature.icon className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-semibold mb-2 text-slate-100">{feature.title}</h3>
              <p className="text-slate-400">{feature.description}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Features;