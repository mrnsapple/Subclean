const knex = require('../config/mysql');
const {Model} = require('objection');

Model.knex(knex);

class Users extends Model {
    static get tableName() {
        return 'users';
    }

    static get jsonSchema() {
        return {
            type: 'object',
            required: ["email", "firstName", "lastName", "token", "password"],

            properties: {
                id: {type: 'integer'},
                email: {type: 'string'},
                firstName: {type: 'string'},
                lastName: {type: 'string'},
                password: {type: ['string', 'null']},
                token: {type: ['string', 'null']}
            }
        };
    }

    static get relationMappings() {
        return {};
    }
}

module.exports = Users;
