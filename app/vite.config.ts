import path from "path";
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import svgrPlugin from 'vite-plugin-svgr'

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: [
      {
        find: "common",
        replacement: path.resolve(__dirname, "src/common"),
      },
    ],
  },
  build: {
    outDir: 'build',
  },
  server: {
    open: true,
    port: 3000,
  },
  plugins: [
    react(),
    svgrPlugin(),
  ],
})