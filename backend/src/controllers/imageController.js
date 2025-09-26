const path = require("path");
const fs = require("fs");

const UPLOADS_DIR = path.join(__dirname, "../../uploads");
const THUMBNAILS_DIR = path.join(UPLOADS_DIR, "thumbnails");

// @desc      Serve an image
// @route     GET /api/images/:filename
// @access    Public
exports.serveImage = (req, res, next) => {
  const { filename } = req.params;
  const filePath = path.join(UPLOADS_DIR, filename);

  if (fs.existsSync(filePath)) {
    res.sendFile(filePath);
  } else {
    res.status(404).json({ success: false, message: "Image not found" });
  }
};

// @desc      Serve a thumbnail
// @route     GET /api/images/thumbnails/:filename
// @access    Public
exports.serveThumbnail = (req, res, next) => {
  const { filename } = req.params;
  const filePath = path.join(THUMBNAILS_DIR, filename);

  if (fs.existsSync(filePath)) {
    res.sendFile(filePath);
  } else {
    res.status(404).json({ success: false, message: "Thumbnail not found" });
  }
};

// @desc      Get image info
// @route     GET /api/images/info/:filename
// @access    Private
exports.getImageInfo = (req, res, next) => {
  // In a real app, you might get metadata from a database
  res
    .status(200)
    .json({ success: true, data: "Info for " + req.params.filename });
};

// @desc      Delete an image
// @route     DELETE /api/images/:filename
// @access    Private
exports.deleteImage = (req, res, next) => {
  // In a real app, you'd delete the file and database record
  res
    .status(200)
    .json({ success: true, data: "Image " + req.params.filename + " deleted" });
};
