const Users = require('../../../database/Users');
const { nanoid } = require('nanoid');
const bcrypt = require('bcrypt');
const register = require('../../../emails/register');
const { ValidationError } = require('objection');

/**
 * @api {post} /v1/users/ ✔ Create new user
 * @apiName createUser
 * @apiGroup Users
 * @apiVersion 1.0.0
 * @apiPermission none
 *
 * @apiHeader Authorization User token with the format "bearer <token>"
 *
 * @apiParam {String} email Email address of the user
 * @apiParam {String} firstName First name of the user
 * @apiParam {String} lastName Last name of the user
 * @apiParam {String} password Password of the user
 * @apiParam {number} group_right ID of the group of right of the user
 *
 * @apiSuccessExample {json} Success-Response :
 *      HTML 200 Success
 *      {
 *          "response": "ok",
 *          "id": 21,
 *          "firstName": "Gérard",
 *          "lastName": "Bouchard"
 *      }
 */

async function postUsers(req, res) {
    let id;
    try {
        req.body.token = nanoid(42);
        req.body.password = await bcrypt.hash(req.body.password, 10);
        id = await Users.query().insert(req.body);
        await register(req.body);
        res.status(201).json({ response: "ok", data: {
                id: id,
                firstName: req.body['firstName'],
                lastName: req.body['lastName'],
                email: req.body['email']
            } });
    } catch (e) {
        if (id) {
            await Users.$query().findById(id).delete();
        }
        if (e.mail && e.errno === "ECONNREFUSED") {
            res.status(500).json({ response: "ko", detail: "Bad email configurations" });
        } else if (e instanceof ValidationError) {
            res.status(400).json({ response: "ko", detail: e.message });
        } else if (e.name && e.name === "UniqueViolationError") {
            res.status(422).json({ response: "ko", detail: "User already exist" });
        } else {
            console.error(e);
            res.status(500).json({ response: "ko", detail: "Internal server error" });
        }
    }
}
module.exports = postUsers;
