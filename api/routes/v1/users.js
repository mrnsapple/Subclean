const express = require('express');
const router = express.Router();

const postUsers = require('./users/postUsers');
const authUsers = require('./users/authUsers');

router.post('/', postUsers);
router.post('/auth', authUsers);

module.exports = router;
