const express = require('express');
const router = express.Router();

const userRouter = require('./v1/users');

//V1 router

router.use('/users', userRouter);

module.exports = router;
