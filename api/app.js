const express = require('express');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const path = require("path");

const app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'docs')));

const v1router = require('./routes/v1router');

  
app.use('/v1', v1router);

module.exports = app;
