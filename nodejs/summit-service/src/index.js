'use strict'
const {EventEmitter} = require('events')
const server = require('./server/server')
const repository = require('./repository/repository')
const config = require('./config/')
const mediator = new EventEmitter()
const log_Prefix = 'summits-application: '

console.log(log_Prefix + '--- Summits Service ---')
console.log(log_Prefix + 'Connecting to summits repository...')

process.on('uncaughtException', (err) => {
  console.error(log_Prefix + 'Unhandled Exception', err)
})

process.on('uncaughtRejection', (err, promise) => {
  console.error(log_Prefix + 'Unhandled Rejection', err)
})

mediator.on('db.ready', (db) => {
  let rep
  repository.connect(db)
    .then(repo => {
      console.log(log_Prefix + 'Connected. Starting Server')
      rep = repo
      return server.start({
        port: config.serverSettings.port,
        repo
      })
    })
    .then(app => {
      console.log(log_Prefix + `Server started succesfully, running on port: ${config.serverSettings.port}.`)
      app.on('close', () => {
        rep.disconnect()
      })
    })
})

mediator.on('db.error', (err) => {
  console.error(log_Prefix + err)
})

// dummy emit call: must be removed when real DB is connected
mediator.emit('db.ready', {})
// config.db.connect(config.dbSettings, mediator)

mediator.emit('boot.ready')
