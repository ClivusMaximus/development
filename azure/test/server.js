/*
const express = require('express');
const app = express();
const port = 3000;
app.use(express.static('testsite'));
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
*/

const http = require('http');
const fs = require('fs');
const path = require('path');

const express = require('express');
const app = express();

const questionsFile = path.join(__dirname, './az-900.json');

// Create a server using Node.js:
const server = http.createServer(app); // If using Express

// Serve the index.html file:
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

server.listen(3000, () => {
    console.log('Server listening on port 3000');
    readQuestions(); 
});