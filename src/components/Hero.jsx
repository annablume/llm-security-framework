import React from 'react';
import { motion } from 'framer-motion';
import { Shield, Lock, Zap } from 'lucide-react';
import { Button } from '@/components/ui/button';

const Hero = () => {
  return (
    <section className="pt-32 pb-20 px-4">
      <div className="container mx-auto max-w-6xl">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="text-center space-y-8"
        >
          <div className="flex justify-center gap-4 mb-8">
            <motion.div
              animate={{ y: [0, -10, 0] }}
              transition={{ duration: 2, repeat: Infinity }}
              className="p-4 bg-cyan-500/10 rounded-2xl border border-cyan-500/20"
            >
              <Shield className="w-12 h-12 text-cyan-400" />
            </motion.div>
            <motion.div
              animate={{ y: [0, -10, 0] }}
              transition={{ duration: 2, delay: 0.3, repeat: Infinity }}
              className="p-4 bg-blue-500/10 rounded-2xl border border-blue-500/20"
            >
              <Lock className="w-12 h-12 text-blue-400" />
            </motion.div>
            <motion.div
              animate={{ y: [0, -10, 0] }}
              transition={{ duration: 2, delay: 0.6, repeat: Infinity }}
              className="p-4 bg-purple-500/10 rounded-2xl border border-purple-500/20"
            >
              <Zap className="w-12 h-12 text-purple-400" />
            </motion.div>
          </div>

          <h1 className="text-5xl md:text-7xl font-bold bg-gradient-to-r from-cyan-400 via-blue-500 to-purple-600 bg-clip-text text-transparent">
            SecureAI Framework
          </h1>
          
          <p className="text-xl md:text-2xl text-slate-400 max-w-3xl mx-auto">
            Enterprise-grade security framework for Large Language Models with advanced threat detection, prompt injection prevention, and real-time monitoring.
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center pt-4">
            <Button 
              size="lg" 
              className="bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-600 hover:to-blue-700 text-lg px-8"
            >
              Get Started
            </Button>
            <Button 
              size="lg" 
              variant="outline" 
              className="border-slate-700 hover:bg-slate-800 text-lg px-8"
            >
              View on GitHub
            </Button>
          </div>

          <div className="pt-8 grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
            <div className="p-6 bg-slate-900/50 rounded-xl border border-slate-800 hover:border-cyan-500/50 transition-all duration-300">
              <div className="text-3xl font-bold text-cyan-400 mb-2">99.9%</div>
              <div className="text-slate-400">Threat Detection Rate</div>
            </div>
            <div className="p-6 bg-slate-900/50 rounded-xl border border-slate-800 hover:border-blue-500/50 transition-all duration-300">
              <div className="text-3xl font-bold text-blue-400 mb-2">&lt;10ms</div>
              <div className="text-slate-400">Average Latency</div>
            </div>
            <div className="p-6 bg-slate-900/50 rounded-xl border border-slate-800 hover:border-purple-500/50 transition-all duration-300">
              <div className="text-3xl font-bold text-purple-400 mb-2">50K+</div>
              <div className="text-slate-400">Active Deployments</div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default Hero;