const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
//https://github.com/rails/webpacker/issues/738

// Add an ProvidePlugin
environment.plugins.prepend('Provide',  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
  })
)

const config = environment.toWebpackConfig()

config.resolve.alias = {
  jquery: "jquery/src/jquery",
}

module.exports = environment
