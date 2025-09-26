const express = require("express");
const {
  getAllUsers,
  getUserById,
  deactivateUser,
  getAllDonations,
  deleteDonation,
  getAllRequests,
  reviewRequest,
  deleteRequest,
  getPlatformStats,
} = require("../controllers/adminController");

const router = express.Router();

const { protect, authorize } = require("../middleware/auth");

// Protect and authorize all routes in this file
router.use(protect);
router.use(authorize("ADMIN"));

router.route("/users").get(getAllUsers);
router.route("/users/:id").get(getUserById).delete(deactivateUser);

router.route("/donations").get(getAllDonations);
router.route("/donations/:id").delete(deleteDonation);

router.route("/requests").get(getAllRequests);
router.route("/requests/:id/review").put(reviewRequest);
router.route("/requests/:id").delete(deleteRequest);

router.route("/stats").get(getPlatformStats);

module.exports = router;
