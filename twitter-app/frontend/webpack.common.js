const HtmlWebPackPlugin = require("html-webpack-plugin");
var webpack = require('webpack');
const path = require('path');
const  ExtractTextPlugin = require('extract-text-webpack-plugin');
const htmlWebpackPlugin = new HtmlWebPackPlugin({
  template: "./src/index.html",
  filename: "./index.html",
  inject:'body'
});

function common(env)
{
    return {
        entry:{
          index:'./src/index.js'
        },
        output: {
          filename: '[name].bundle.js',
          chunkFilename: '[name].bundle.js',
          path: path.resolve(__dirname, 'dist')
        },
        plugins: [htmlWebpackPlugin],
        //output:'./dist/main.js',
        module: {
          rules: [
           {
             test: /\.js$/,
            exclude: /node_modules/,
            use: {
              loader: "babel-loader"
            }
          }
          ,
            { 
              test: /\.(jpg|png|woff|woff2|eot|ttf|svg)$/, 
              use: {
                loader:'file-loader',
                options:{
                  name (file) {
                    if (env === 'development') {
                      return '[path][name].[ext]'
                    }
              
                    return '[hash].[ext]'
                  }
                }
              }
             
             },
          {
            test: /\.css$/,
            use: [
              {
                loader: "style-loader"
              },
              {
                loader: "css-loader",
                options: {
                  modules: true,
                  importLoaders: 1,
                  localIdentName: "[name]_[local]_[hash:base64].[ext]",
                  sourceMap: true,
                  minimize: true
                }
              }
            ]
          },
          {
            test: /\.scss$/,
              use: [{
                loader: "style-loader"
              }, {
                loader: "css-loader" ,
                options: {
                  modules: true,
                  importLoaders: 1,
                  localIdentName: "[name]_[local]_[hash:base64].[ext]",
                  sourceMap: true,
                  minimize: true
                }
              }, {
                loader: "sass-loader",
                options:{
                  modules: true,
                  importLoaders: 1,
                  localIdentName: "[name]_[local]_[hash:base64].[ext]",
                  sourceMap: true,
                  minimize: true
                }
              }]
        }
          
        ]
      },
      plugins: [
      htmlWebpackPlugin, 
        new webpack.HotModuleReplacementPlugin()
      ]
  }
  
}

module.exports = common;