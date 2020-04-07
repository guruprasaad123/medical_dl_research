const merge = require('webpack-merge');
const common = require('./webpack.common.js');
const path = require('path');

const fs = require('fs');

const dotenv = require('dotenv');
const config = dotenv.parse(fs.readFileSync('.env.dev'));

console.log('config => ',config );

for (let [key , value ] of Object.entries(config) )
{
process.env[key] = value;
console.log('config.set => ',process.env[key])

}

module.exports = merge( common('development'),{
  mode:'development',
  devtool: 'inline-source-map',
  devServer: {
    historyApiFallback: {
      index: '/'
    },
    contentBase: path.join(__dirname, 'src'),
    compress: true,
    port: 8080
  }
});
