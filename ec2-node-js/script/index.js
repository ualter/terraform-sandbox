// content of index.js
const http = require('http') 
const port = 80

const requestHandler = (request, response) => {

  response.setHeader('Content-Type', 'application/json');
  var msg = {}
  msg = JSON.stringify(request.headers)
  
  console.log(msg)
  response.end(msg)
}

const server = http.createServer(requestHandler)

server.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
})