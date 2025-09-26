const express = require("express");
const {
  getDonations,
  getDonationById,
  createDonation,
  updateDonation,
  deleteDonation,
  getMyDonations,
  getDonationStats,
} = require("../controllers/donationController");

const router = express.Router();

const { protect, authorize } = require("../middleware/auth");
const { upload, processImage } = require("../middleware/upload");

router
  .route("/")
  .get(getDonations)
  .post(
    protect,
    authorize("DONOR"),
    upload.single("image"),
    processImage,
    createDonation
  );

router.route("/my/donations").get(protect, getMyDonations);

router.route("/stats").get(getDonationStats);

router
  .route("/:id")
  .get(getDonationById)
  .put(protect, authorize("DONOR", "ADMIN"), updateDonation)
  .delete(protect, authorize("DONOR", "ADMIN"), deleteDonation);

module.exports = router;
