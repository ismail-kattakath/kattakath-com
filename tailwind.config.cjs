module.exports = {
  content: [
    "./src/**/*.{astro,js,jsx,ts,tsx,mdx,md}",
    "./public/**/*.html"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('tailwind-bootstrap-grid'),
  ],
  darkMode: 'class',
};
