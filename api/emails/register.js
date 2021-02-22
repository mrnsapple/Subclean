const mail = require('../config/mails');
const twig = require('twig');

function register(user) {
    return new Promise((resolve, reject) => {
        twig.renderFile('./emails/templates/newAccount.twig', {
            name: `${user["firstName"]} ${user["lastName"]}`,
            url: `${process.env["APP_URL"]}/activate?email=${user["email"]}&token=${user["token"]}`,
            title: `Activer votre compte`,
            favicon: `${process.env["API_URL"]}/assets/images/favicon.ico`,
            logo: `${process.env["API_URL"]}/assets/images/logo.png`
        }, async (err, html) => {
            if (err) {
                reject(err);
            } else {
                mail.sendMail({
                    sender: `SubClean <${process.env["MAIL_MAIL"]}>`,
                    to: user['email'],
                    subject: `Activer votre compte`,
                    html: html
                }).then(() => {
                    resolve();
                }).catch((err) => {
                    reject({"mail": true, err});
                });
            }
        });
    });
}

module.exports = register;
