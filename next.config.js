/** @type {import('next').NextConfig} */
const config = {
  output: 'standalone',
  swcMinify: true,
  optimizeFonts: false // [!code ++]
};

module.exports = config;
