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
      },
      screens: {
        '3xl': '1920px',
      },
      minWidth: { 
        80: '20rem',
      }
    },
    colors: { ...colors }
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
