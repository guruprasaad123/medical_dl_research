const merge = require('webpack-merge');
const common = require('./webpack.common.js');

const fs = require('fs');

const dotenv = require('dotenv');
const config = dotenv.parse(fs.readFileSync('.env'));

for (let [key , value ] of Object.entries(config) )
{
process.env[key] = value;
}

module.exports = merge(common('production'), {
  mode: 'production',
});