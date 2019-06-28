const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = process.env.PORT || 3002;

app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

const routes = require('./api/routes');
routes(app);

app.listen(port, function() {
    console.log('summits-application: User service server started on port: ' + port);
});
