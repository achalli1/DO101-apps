var express = require('express');
app = express();

app.get('/', function (req, res) {
  res.send('Hello Worldss!\n');
});

app.get('/mars', function(req, res) {
  res.send('Hello Marsss47!\n');
});

app.listen(8080, function () {
  console.log('Example app listening on port 8080!');
});

