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
const { uuid, isUuid } = require('uuidv4')

const app = express();

app.use(express.json());

/***
 * Métodos HTTP
 * 
 * GET: Buscar informações no backend
 * POST: Criar uma informação no backend
 * PUT/PATH: Alterar informação no backend
 * DELETE: usado para deleter informação no backend
 */
/**
 * Tipos de parâmetros
 * 
 * Query Params: Filtros e Paginação
 * Route Params: Identificar recurso para Atualizar/Deletar
 * Request Body: Conteudo na hora de criar ou atualizar (JSON) * 
 */
/**
 * Middleware:
 * 
 * Interceptador de requisições que pode interromper totalente a requisição ou alterar dados da requisição.
 */

const tickets = [];

//Middleware
function logRequest(request, response, next){
    console.log(request);
    const {method, url} = request;
    const logLabel = `[${method.toUpperCase()}] ${url}`
    console.time(logLabel); //Inicia a contagem até o próximo console.time com a mesma variável. Retorna o tempo entre elas.
    next(); //Chama o próximo middleware
    console.timeEnd(logLabel);
}

function validateTicketId(request, response, next){
    const { id } = request.params;
    if(!isUuid(id)) {
        return response.status(400).json({message: 'Invalid ticket ID.'});
    }
    return next();
}

app.use(logRequest);

app.use('/tickets/:id', validateTicketId);

app.get('/tickets', (request, response) => {
    // Capturando query caso venha com filtragem no campo name.
    const { name } = request.query;

    //Verificando se existe na array principal o match
    const results = name
    ? tickets.filter(ticket => ticket.name.includes(name)) // Caso encontrado retorna a lista com filtro
    : tickets                                              // Caso não encontrado returna tudo.
    return response.json(results)
})

app.post('/tickets', (request, response) => {
    // Caputurando dados do body da requisição POST
    const { name, ticket_name, itens, comment } = request.body;
    
    // Criando objeto com os dados, usando o pacore uuid para criar o ID.
    const ticket = { id: uuid(), name, ticket_name, itens, comment }

    // Adicionando no array principal o objeto.
    tickets.push(ticket);

    return response.json(ticket);
})

app.put('/tickets/:id', (request, response) => {
    // Capturando o ID que será feita a alteração
    const {id} = request.params;
    // Capturando dados atualizados do body ra requisição POST.
    const { name, ticket_name, itens, comment } = request.body;
    // Pesquisando número do ID do campo que será atualizado dentro do array principal
    const ticketIndex = tickets.findIndex(project => project.id === id );
    // Verificando se ID informado existe e retornando um erro 400 caso não exista.
    if ( ticketIndex < 0 ){
        return response.status(400).json('Ticket not found.')
    }
    // Recriando objeto atualizado
    const ticket = { id: uuid(), name, ticket_name, itens, comment }
    // Substituindo no array principal no mesmo id e substituindo com objeto atualizado.
    tickets[ticketIndex] = ticket;

    return response.json(ticket);
})

app.delete('/tickets/:id', (request, response) => {
    // Capturando o ID que será feita a alteração
    const {id} = request.params;
    // Pesquisando número do ID do campo que será excluido dentro do array principal
    const ticketIndex = tickets.findIndex(project => project.id === id );
    // Verificando se ID informado existe e retornando um erro 400 caso não exista.
    if ( ticketIndex < 0 ){
        return response.status(400).json('Ticket not found.')
    }
    //Excluindo o objeto do array principal
    tickets.splice(ticketIndex,1);

    return response.status(204).send();
})

app.listen(3333, () => {
    console.log('Back-end started!')
})
" > src/index.js
echo "Iniciando NODE em $PWD/src/index.js"
echo "Acesse a aplicação http://localhost:3333/"
yarn dev
echo "Aplicação encerrada"
