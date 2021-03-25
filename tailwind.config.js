const colors = require('tailwindcss/colors')

module.exports = {
  purge: {
    content: [
      './app/**/*.html.erb',
    ],
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', 'sans-serif'],
      },
      spacing: {
        108: '27rem',
        120: '30rem',
      }
    },
    colors: { ...colors },
    minWidth: { 
      80: '20rem',
    }
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
}
