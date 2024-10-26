// Backend Service (Node.js/Express) javaScript
// backend/server.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/api', (req, res) => {
  res.send('Hello from the backend!');
});

app.listen(port, () => {
  console.log(`Backend service listening at http://localhost:${port}`);
});
