const donations = require("./routes/donations");
const requests = require("./routes/requests");
const users = require("./routes/users");
const admin = require("./routes/admin");
const notifications = require("./routes/notifications");

// Connect to database
connectDB();

const app = express();

app.use("/api/donations", donations);
app.use("/api/requests", requests);
app.use("/api/users", users);
app.use("/api/admin", admin);
app.use("/api/notifications", notifications);

// Error Handler Middleware
app.use(errorHandler);
