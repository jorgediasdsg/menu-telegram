mkdir backend
mkdir backend/src
echo "/backend/node_modules" > .gitignore
cd backend
yarn init -y
yarn add express
echo "
const express = require('express');
const app = express();
app.get('/projects', (require, response) => {
    return response.send('Hello World')
});
app.listen(3333);
" > src/index.js
firefox http://localhost/3333
node src/index.js