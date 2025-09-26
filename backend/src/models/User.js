const mysql = require("mysql2/promise");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { promisePool } = require("../config/database");

// Private helper to attach methods to a raw user object
const _attachMethods = (user) => {
  if (!user) {
    return null;
  }

  // Create a new object to avoid modifying the original row packet
  const userWithMethods = { ...user };

  userWithMethods.matchPassword = async function (enteredPassword) {
    // Ensure the password field exists before trying to compare
    if (!this.password) {
      return false;
    }
    return await bcrypt.compare(enteredPassword, this.password);
  };

  userWithMethods.getSignedJwtToken = function () {
    return jwt.sign({ id: this.id }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRES_IN,
    });
  };

  return userWithMethods;
};

const UserSchema = {
  create: async function ({ name, email, password, role }) {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const [result] = await promisePool.execute(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)",
      [name, email, hashedPassword, role]
    );
    const [rows] = await promisePool.execute(
      "SELECT id, name, email, role, created_at, updated_at FROM users WHERE id = ?",
      [result.insertId]
    );
    // Attach methods to the newly created user object
    return _attachMethods(rows[0]);
  },

  findOne: async function (query, selectPassword = false) {
    const key = Object.keys(query)[0];
    const value = query[key];

    const columns = selectPassword
      ? "id, name, email, password, role, created_at, updated_at"
      : "id, name, email, role, created_at, updated_at";

    const [rows] = await promisePool.execute(
      `SELECT ${columns} FROM users WHERE ${key} = ? LIMIT 1`,
      [value]
    );

    if (rows.length > 0) {
      return _attachMethods(rows[0]);
    }
    return null;
  },

  findById: async function (id) {
    const [rows] = await promisePool.execute(
      "SELECT id, name, email, role, created_at, updated_at FROM users WHERE id = ?",
      [id]
    );
    if (rows.length > 0) {
      return _attachMethods(rows[0]);
    }
    return null;
  },
};

module.exports = UserSchema;
