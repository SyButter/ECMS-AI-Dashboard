/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        brand: {
          blue:      '#1E3A8A',
          lightblue: '#3B82F6',
          cyan:      '#06B6D4',
          dark:      '#0F172A',
        }
      }
    }
  },
  plugins: [],
}
