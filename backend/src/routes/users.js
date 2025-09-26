const express = require("express");
const {
  updateProfile,
  changePassword,
  deactivateAccount,
  getUserStats,
} = require("../controllers/userController");

const router = express.Router();

const { protect } = require("../middleware/auth");

router.use(protect);

router.route("/profile").put(updateProfile);
router.route("/password").put(changePassword);
router.route("/account").delete(deactivateAccount);
router.route("/stats").get(getUserStats);

module.exports = router;
