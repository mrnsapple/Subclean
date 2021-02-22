const jwt = require('jsonwebtoken');
const Users = require('../database/Users');

/**
 * Middleware that check the existence and validity of the token given by the user
 * @param req
 * @param res
 * @param next
 * @returns {Promise<void>}
 */

async function checkToken(req, res, next) {
    let token = req.get("Authorization") ? req.get("Authorization").split(' ') : undefined;
    if (token && token[0] && token[0].toLowerCase() === "bearer" && token[1] !== "") {
        try {
            let decoded = jwt.verify(token[1], process.env["SECRET"]);
            let user = await Users.query().findById(decoded["id"]);
            if (user) {
                res.locals["user"] = user;
                next();
            } else {
                res.status(404).json({"error": "Account deleted or token invalid"});
            }
        } catch (e) {
            res.status(401).json({"error": "Invalid token"});
        }
    } else {
        res.status(401).json({"error": "Empty or malformed token"});
    }
}

module.exports = checkToken;
