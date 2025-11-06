import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import path from 'path'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  // Load from root .env file
  // eslint-disable-next-line no-undef
  const env = loadEnv(mode, path.resolve(__dirname, '..'), '')
  return {
    server: {
      port: parseInt(env.FRONTEND_PORT) || 6166
    },
    plugins: [
      react({
        babel: {
          plugins: [['babel-plugin-react-compiler']]
        }
      }),
      tailwindcss()
    ],
    resolve: {
      alias: {
        // eslint-disable-next-line no-undef
        '@': path.resolve(__dirname, './src')
      }
    }
  }
})
