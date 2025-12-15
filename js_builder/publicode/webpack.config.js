import path from 'path';
import { fileURLToPath } from 'url';

// Nécessaire pour recréer __dirname qui n'existe pas en mode module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default {
  mode: 'production',
  entry: './index.js',
  output: {
    filename: 'publicodes_bundle.js',
    path: path.resolve(__dirname, 'dist'),
    globalObject: 'this',
  },
  resolve: {
    fallback: {
      "fs": false,
      "path": false
    }
  }
};