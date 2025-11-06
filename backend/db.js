const { Pool } = require("pg");

const pool = new Pool({
    user: "user",
    host: "localhost",
    database: "restaurant",
    password: "pass1234",
    port: 5432,
});

module.exports = pool;
