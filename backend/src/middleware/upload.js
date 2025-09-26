const multer = require("multer");
const sharp = require("sharp");
const path = require("path");
const fs = require("fs");
const { v4: uuidv4 } = require("uuid");

// Ensure uploads directory exists
const uploadsDir = path.join(__dirname, "../../uploads");
const thumbnailsDir = path.join(uploadsDir, "thumbnails");

if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

if (!fs.existsSync(thumbnailsDir)) {
  fs.mkdirSync(thumbnailsDir, { recursive: true });
}

// Configure multer for memory storage
const storage = multer.memoryStorage();

// File filter for images only
const fileFilter = (req, file, cb) => {
  if (file.mimetype.startsWith("image/")) {
    cb(null, true);
  } else {
    cb(new Error("Only image files are allowed!"), false);
  }
};

// Multer configuration
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
});

// Image processing middleware
const processImage = async (req, res, next) => {
  if (!req.file) {
    return next();
  }

  try {
    const filename = `${uuidv4()}.webp`;
    const thumbnailFilename = `${uuidv4()}_thumb.webp`;

    const imagePath = path.join(uploadsDir, filename);
    const thumbnailPath = path.join(thumbnailsDir, thumbnailFilename);

    // Process main image (max 1200px width, maintain aspect ratio)
    await sharp(req.file.buffer)
      .resize(1200, null, {
        withoutEnlargement: true,
        fit: "inside",
      })
      .webp({ quality: 85 })
      .toFile(imagePath);

    // Process thumbnail (300x300px, cropped to center)
    await sharp(req.file.buffer)
      .resize(300, 300, {
        fit: "cover",
        position: "center",
      })
      .webp({ quality: 80 })
      .toFile(thumbnailPath);

    // Add file info to request
    req.fileInfo = {
      originalName: req.file.originalname,
      filename: filename,
      thumbnailFilename: thumbnailFilename,
      path: `/uploads/${filename}`,
      thumbnailPath: `/uploads/thumbnails/${thumbnailFilename}`,
      size: req.file.size,
      mimetype: req.file.mimetype,
    };

    next();
  } catch (error) {
    console.error("Image processing error:", error);
    return res.status(500).json({
      success: false,
      message: "Error processing image",
      error: error.message,
    });
  }
};

// Error handling middleware for multer
const handleUploadError = (error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        success: false,
        message: "File too large. Maximum size is 5MB.",
      });
    }
  }

  if (error.message === "Only image files are allowed!") {
    return res.status(400).json({
      success: false,
      message: "Only image files are allowed!",
    });
  }

  next(error);
};

module.exports = {
  upload,
  processImage,
  handleUploadError,
};
