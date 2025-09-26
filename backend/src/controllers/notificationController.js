const Notification = require("../models/Notification");

// Get all notifications for the logged-in user
exports.getMyNotifications = async (req, res, next) => {
  try {
    const notifications = await Notification.findByUserId(req.user.id);
    res.status(200).json({
      success: true,
      count: notifications.length,
      notifications,
    });
  } catch (error) {
    next(error);
  }
};

// Mark a specific notification as read
exports.markNotificationAsRead = async (req, res, next) => {
  try {
    const { id } = req.params;
    const success = await Notification.markAsRead(id);

    if (!success) {
      return res.status(404).json({
        success: false,
        message: "Notification not found or already read",
      });
    }

    res.status(200).json({
      success: true,
      message: "Notification marked as read",
    });
  } catch (error) {
    next(error);
  }
};

// Mark all of the user's notifications as read
exports.markAllNotificationsAsRead = async (req, res, next) => {
  try {
    const count = await Notification.markAllAsRead(req.user.id);
    res.status(200).json({
      success: true,
      message: `${count} notifications marked as read`,
    });
  } catch (error) {
    next(error);
  }
};
