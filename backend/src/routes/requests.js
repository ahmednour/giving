const express = require("express");
const {
  getRequests,
  getRequestById,
  getMyRequests,
  createRequest,
  updateRequestStatus,
  deleteRequest,
  getRequestStats,
} = require("../controllers/requestController");
const { protect, authorize } = require("../middleware/auth");

const router = express.Router();

router.use(protect);

router.route("/").get(getRequests).post(authorize("RECEIVER"), createRequest);

router.route("/my").get(authorize("RECEIVER"), getMyRequests);

router.route("/stats").get(authorize("ADMIN"), getRequestStats);

router.route("/:id").get(getRequestById).delete(deleteRequest);

router.route("/:id/status").put(updateRequestStatus);

module.exports = router;
