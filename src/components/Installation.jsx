import React from 'react';
import { motion } from 'framer-motion';
import { Copy, Check, Terminal } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useToast } from '@/components/ui/use-toast';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';

const Installation = () => {
  const { toast } = useToast();
  const [copiedCommand, setCopiedCommand] = React.useState(null);

  const installCommands = {
    pip: 'pip install secureai-framework',
    conda: 'conda install -c conda-forge secureai-framework',
    poetry: 'poetry add secureai-framework'
  };

  const copyToClipboard = (command, type) => {
    navigator.clipboard.writeText(command);
    setCopiedCommand(type);
    toast({
      title: "Copied to clipboard!",
      description: "Installation command has been copied.",
    });
    setTimeout(() => setCopiedCommand(null), 2000);
  };

  return (
    <section id="installation" className="py-20 px-4">
      <div className="container mx-auto max-w-6xl">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-4xl md:text-5xl font-bold mb-4 bg-gradient-to-r from-cyan-400 to-blue-500 bg-clip-text text-transparent">
            Installation
          </h2>
          <p className="text-xl text-slate-400 max-w-3xl mx-auto">
            Choose your preferred package manager
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6, delay: 0.2 }}
          className="max-w-3xl mx-auto"
        >
          <Tabs defaultValue="pip" className="w-full">
            <TabsList className="grid w-full grid-cols-3 bg-slate-900 border border-slate-800">
              <TabsTrigger value="pip">pip</TabsTrigger>
              <TabsTrigger value="conda">conda</TabsTrigger>
              <TabsTrigger value="poetry">poetry</TabsTrigger>
            </TabsList>
            
            {Object.entries(installCommands).map(([type, command]) => (
              <TabsContent key={type} value={type} className="mt-6">
                <div className="relative group">
                  <div className="flex items-center gap-3 bg-slate-950 border border-slate-800 rounded-lg p-4">
                    <Terminal className="w-5 h-5 text-cyan-400" />
                    <code className="flex-1 text-cyan-300">{command}</code>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => copyToClipboard(command, type)}
                      className="hover:bg-slate-800"
                    >
                      {copiedCommand === type ? (
                        <Check className="w-4 h-4 text-green-400" />
                      ) : (
                        <Copy className="w-4 h-4" />
                      )}
                    </Button>
                  </div>
                </div>
              </TabsContent>
            ))}
          </Tabs>

          <div className="mt-12 p-6 bg-slate-900/50 rounded-xl border border-slate-800">
            <h3 className="text-xl font-semibold mb-4 text-slate-100">Requirements</h3>
            <ul className="space-y-2 text-slate-400">
              <li className="flex items-start gap-2">
                <span className="text-cyan-400 mt-1">•</span>
                <span>Python 3.8 or higher</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-cyan-400 mt-1">•</span>
                <span>pip 21.0 or higher</span>
              </li>
              <li className="flex items-start gap-2">
                <span className="text-cyan-400 mt-1">•</span>
                <span>Compatible with major LLM providers (OpenAI, Anthropic, Cohere, etc.)</span>
              </li>
            </ul>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default Installation;