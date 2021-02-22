const mail = require('nodemailer');

let options = {
    host: process.env["MAIL_HOST"],
    port: process.env["MAIL_PORT"],
    tls: {
        rejectUnauthorized: false,
    }
}

if (process.env["MAIL_USERNAME"] && process.env["MAIL_PASSWORD"]) {
    options.auth = {
        user: process.env["MAIL_USERNAME"],
        pass: process.env["MAIL_PASSWORD"]
    }
}

let transporter = mail.createTransport(options);

module.exports = transporter;