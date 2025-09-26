const express = require("express");
const {
  getMyNotifications,
  markNotificationAsRead,
  markAllNotificationsAsRead,
} = require("../controllers/notificationController");
const { protect } = require("../middleware/auth");

const router = express.Router();

// All routes in this file are protected
router.use(protect);

router.route("/").get(getMyNotifications).put(markAllNotificationsAsRead);

router.route("/:id/read").put(markNotificationAsRead);

module.exports = router;
