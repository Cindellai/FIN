/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/javascripts/**/*.js',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui')
  ],
}
