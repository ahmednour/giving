const { promisePool } = require("../config/database");

class Notification {
  // Create a new notification
  static async create(userId, message) {
    const [result] = await promisePool.execute(
      "INSERT INTO notifications (user_id, message) VALUES (?, ?)",
      [userId, message]
    );
    return result.insertId;
  }

  // Find notifications by user ID
  static async findByUserId(userId) {
    const [rows] = await promisePool.query(
      "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC",
      [userId]
    );
    return rows;
  }

  // Mark a notification as read
  static async markAsRead(notificationId) {
    const [result] = await promisePool.execute(
      "UPDATE notifications SET is_read = TRUE WHERE id = ?",
      [notificationId]
    );
    return result.affectedRows > 0;
  }

  // Mark all notifications for a user as read
  static async markAllAsRead(userId) {
    const [result] = await promisePool.execute(
      "UPDATE notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE",
      [userId]
    );
    return result.affectedRows;
  }
}

module.exports = Notification;
