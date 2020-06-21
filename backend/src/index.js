
const express = require('express');
const { uuid } = require('uuidv4')

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
 * Requesrt Body: Conteudo na hora de criar ou atualizar (JSON) * 
 */

const tickets = [];

app.get('/tickets', (request, response) => {
    const query = request.query
    return response.json(tickets)
})

app.post('/tickets', (request, response) => {
    const { name, ticket_name, itens, comment } = request.body;
    
    const ticket = { id: uuid(), name, ticket_name, itens, comment }

    tickets.push(ticket);

    return response.json(ticket);
})

app.put('/tickets/:id', (request, response) => {
    const {id} = request.params;
    const { name, ticket_name, itens, comment } = request.body;

    const ticketIndex = tickets.findIndex(project => project.id === id );

    if ( ticketIndex < 0 ){
        return response.status(400).json('Ticket not found.')
    }

    const ticket = { id: uuid(), name, ticket_name, itens, comment }

    tickets[ticketIndex] = ticket;

    return response.json(ticket);
})

app.delete('/tickets/:id', (request, response) => {
    const {id} = request.params;

    const ticketIndex = tickets.findIndex(project => project.id === id );

    if ( ticketIndex < 0 ){
        return response.status(400).json('Ticket not found.')
    }

    tickets.splice(ticketIndex,1);

    return response.status(204).send();
})

app.listen(3333, () => {
    console.log('Back-end started!')
})

