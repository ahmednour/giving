require("dotenv").config();

const jwtConfig = {
  secret:
    process.env.JWT_SECRET || "your-super-secret-jwt-key-change-in-production",
  expiresIn: process.env.JWT_EXPIRES_IN || "24h",
  refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || "7d",
};

module.exports = jwtConfig;
