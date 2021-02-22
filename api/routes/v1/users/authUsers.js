const Users = require('../../../database/Users');
const bcrypt = require("bcrypt");
const jwt = require('jsonwebtoken');

/**
 * @api {post} /v1/users/auth ✔ Get an jwt token
 * @apiName connectUser
 * @apiGroup Users
 * @apiVersion 1.0.0
 *
 * @apiParam {String} email email address of the user
 * @apiParam {String} password password of the user
 *
 * @apiSuccessExample {json} Success-Response :
 *      HTML 200 Success
 *      {
 *          "response": "ok",
 *          "token": "123456",
 *          "email": "example@subclean.tech",
 *          "firstName: "Gerard",
 *          "lastName": "BOUCHARD",
 *          "group_right": 2
 *      }
 */

async function auth(req, res) {
    let email = req.body["email"];
    let password = req.body["password"];
    if (email && password) {
        try {
            let user = await Users.query().findOne("email", email);
            if (user && user["password"] !== null) {
                let valid = await bcrypt.compare(password, user["password"]);
                if (valid) {
                    let token = jwt.sign({
                        id: user["id"],
                        email: user["email"],
                        firstName: user["firstName"],
                        lastName: user["lastName"]
                    }, process.env.SECRET);
                    res.status(200).json({
                        "response": "ok",
                        "token": token,
                        "firstName": user["firstName"],
                        "lastName": user["lastName"],
                        "fullName": `${user["firstName"]} ${user['lastName']}`,
                        "email": user["email"]
                    })
                } else {
                    res.status(400).json({response: "ko", detail: "Wrong email or password"});
                }
            } else if (user && user["password"] === null) {
                res.status(400).json({response: "ko", detail: "You first need to validate you account"});
            } else {
                res.status(400).json({response: "ko", detail: "Wrong email or password"});
            }
        } catch (e) {
            console.error(e);
            res.status(500).json({response: "ko", detail: "Internal server error"});
        }
    } else {
        res.status(400).json({response: "ko", detail: "email and password require"});
    }
}

module.exports = auth;
