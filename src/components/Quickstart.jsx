import React from 'react';
import { motion } from 'framer-motion';
import { Copy, Check } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useToast } from '@/components/ui/use-toast';

const Quickstart = () => {
  const { toast } = useToast();
  const [copiedIndex, setCopiedIndex] = React.useState(null);

  const steps = [
    {
      title: 'Install the package',
      code: 'pip install secureai-framework'
    },
    {
      title: 'Initialize the framework',
      code: `from secureai import SecureAI

# Initialize with your configuration
secure = SecureAI(
    api_key="your-api-key",
    threat_level="high"
)`
    },
    {
      title: 'Protect your LLM calls',
      code: `# Wrap your LLM calls
response = secure.protect(
    prompt=user_input,
    model="gpt-4"
)

# Access the safe response
print(response.content)`
    }
  ];

  const copyToClipboard = (code, index) => {
    navigator.clipboard.writeText(code);
    setCopiedIndex(index);
    toast({
      title: "Copied to clipboard!",
      description: "Code snippet has been copied successfully.",
    });
    setTimeout(() => setCopiedIndex(null), 2000);
  };

  return (
    <section id="quickstart" className="py-20 px-4 bg-slate-900/30">
      <div className="container mx-auto max-w-6xl">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-4xl md:text-5xl font-bold mb-4 bg-gradient-to-r from-cyan-400 to-blue-500 bg-clip-text text-transparent">
            Quickstart Guide
          </h2>
          <p className="text-xl text-slate-400 max-w-3xl mx-auto">
            Get started with SecureAI Framework in just a few minutes
          </p>
        </motion.div>

        <div className="space-y-8 max-w-4xl mx-auto">
          {steps.map((step, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: -20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              className="space-y-3"
            >
              <div className="flex items-center gap-3">
                <div className="flex items-center justify-center w-8 h-8 rounded-full bg-gradient-to-r from-cyan-500 to-blue-600 text-white font-bold">
                  {index + 1}
                </div>
                <h3 className="text-xl font-semibold text-slate-100">{step.title}</h3>
              </div>
              <div className="relative group">
                <pre className="bg-slate-950 border border-slate-800 rounded-lg p-4 overflow-x-auto">
                  <code className="text-sm text-cyan-300">{step.code}</code>
                </pre>
                <Button
                  size="sm"
                  variant="ghost"
                  className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                  onClick={() => copyToClipboard(step.code, index)}
                >
                  {copiedIndex === index ? (
                    <Check className="w-4 h-4 text-green-400" />
                  ) : (
                    <Copy className="w-4 h-4" />
                  )}
                </Button>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Quickstart;