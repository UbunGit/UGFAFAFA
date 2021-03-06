'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  BASE_API: '"http://10.10.11.120:5000"',
  SOCKET_API: '"http://10.10.11.120:8081"',
})
