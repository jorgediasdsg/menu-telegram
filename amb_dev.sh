#!/bin/bash
#
#   Script de criação de ambiente de desenvolvimento.
#
#   Será criado os diretórios e as dependencias básicas de um projeto.
#
#
#
echo "Criando diretórios"
mkdir backend
mkdir backend/src
echo "Criando .gitignore"
echo "/backend/node_modules" > .gitignore
cd backend
echo "Iniciando yarn"
yarn init -y
echo "Adicionando Express"
yarn add express
echo "Adicionando NodeMON em Desenvolvimento"
yarn add nodemon -D
echo "Adicionando UUIDv4"
yarn add uuidv4 -D
echo "Configurando o NodeMON"
sed -i 's/"license": "MIT",/"license": "MIT","scripts":{"dev":"nodemon"},/g' package.json
sed -i 's/"main": "index.js",/"main": "src\/index.js",/g' package.json
echo "Criando hello world"
echo "
const express = require('express');
const app = express();
app.get('/', (require, response) => {
    return response.json({message:'Hello World'});
});
app.listen(3333, () => {
    console.log('Back-end started!')
});
" > src/index.js
echo "Iniciando NODE em $PWD/src/index.js"
echo "Acesse a aplicação http://localhost:3333/"
yarn dev
echo "Aplicação encerrada"
