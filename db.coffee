mysql = require('mysql')

dbconfig = require('./dbconfig').config

pool = mysql.createPool(dbconfig)

exports.release =(conn)->
  conn.end((err)->
    console.log('conn is closed!')
  )
exports.query=(options)->
  pool.getConnection((err,conn)->
    if err
      console.log('connect err@!')
      throw err
    sql = options.sql
    args = options.args
    handler = options.handler
    if !args
      q = conn.query(sql,(err,res)->
        if err
          console.log('err')
          throw err
        handler(res)
      )
      console.log(q.sql)
    return
  )
