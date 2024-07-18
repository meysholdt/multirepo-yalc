// app/server.js
const express = require('express');
const sayHello = require('lib');

const app = express();
const port = 3000;

app.get('/', (req, res) => {
    const htmlContent = `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Minimalistic App</title>
        </head>
        <body>
            <h1>${sayHello()}</h1>
        </body>
        </html>
    `;
    res.send(htmlContent);
});

app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});