const express = require("express");
const router = express.Router();
const {
  serveImage,
  serveThumbnail,
  getImageInfo,
  deleteImage,
} = require("../controllers/imageController");
const { protect } = require("../middleware/auth");

// Public routes for serving images
router.get("/:filename", serveImage);
router.get("/thumbnails/:filename", serveThumbnail);

// Protected routes for image management
router.get("/info/:filename", protect, getImageInfo);
router.delete("/:filename", protect, deleteImage);

module.exports = router;
