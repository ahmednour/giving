const Donation = require("../models/Donation");

// Get all donations with pagination and filters
const getDonations = async (req, res) => {
  try {
    const { page = 1, limit = 20, status, category, search } = req.query;

    const offset = (parseInt(page) - 1) * parseInt(limit);

    const options = {
      limit: parseInt(limit),
      offset,
      status,
      category,
      search,
    };

    const donations = await Donation.findAll(options);

    res.status(200).json({
      success: true,
      data: {
        donations,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: donations.length,
        },
      },
    });
  } catch (error) {
    console.error("Get donations error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get donations",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get donation by ID
const getDonationById = async (req, res) => {
  try {
    const { id } = req.params;

    const donation = await Donation.findById(id);
    if (!donation) {
      return res.status(404).json({
        success: false,
        message: "Donation not found",
      });
    }

    res.status(200).json({
      success: true,
      data: { donation },
    });
  } catch (error) {
    console.error("Get donation by ID error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get donation",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Create new donation (Donor only)
const createDonation = async (req, res) => {
  try {
    const { title, description, category } = req.body;
    const donor_id = req.user.id;

    // Use uploaded image if available, otherwise use provided image_url
    const image_url = req.fileInfo ? req.fileInfo.path : req.body.image_url;

    const donation = await Donation.create({
      title,
      description,
      image_url,
      category,
      donor_id,
    });

    res.status(201).json({
      success: true,
      message: "Donation created successfully",
      data: { donation },
    });
  } catch (error) {
    console.error("Create donation error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to create donation",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Update donation
const updateDonation = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = { ...req.body };
    const user = req.user;

    // Use uploaded image if available
    if (req.fileInfo) {
      updateData.image_url = req.fileInfo.path;
    }

    // Only donor can update their own donations, or admin can update any
    const donor_id = user.role === "admin" ? null : user.id;

    const donation = await Donation.update(id, updateData, donor_id);

    res.status(200).json({
      success: true,
      message: "Donation updated successfully",
      data: { donation },
    });
  } catch (error) {
    console.error("Update donation error:", error);

    if (error.message === "Donation not found or access denied") {
      return res.status(404).json({
        success: false,
        message:
          "Donation not found or you do not have permission to update it",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to update donation",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Delete donation
const deleteDonation = async (req, res) => {
  try {
    const { id } = req.params;
    const user = req.user;

    // Only donor can delete their own donations, or admin can delete any
    const donor_id = user.role === "admin" ? null : user.id;

    await Donation.delete(id, donor_id);

    res.status(200).json({
      success: true,
      message: "Donation deleted successfully",
    });
  } catch (error) {
    console.error("Delete donation error:", error);

    if (error.message === "Donation not found or access denied") {
      return res.status(404).json({
        success: false,
        message:
          "Donation not found or you do not have permission to delete it",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to delete donation",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get current user's donations
const getMyDonations = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const donorId = req.user.id;

    const result = await Donation.findByDonor(donorId, {
      page: parseInt(page),
      limit: parseInt(limit),
    });

    res.json(result);
  } catch (error) {
    console.error("Get my donations error:", error);
    res
      .status(500)
      .json({ message: "Error retrieving donations", error: error.message });
  }
};

// Get donations with pending requests (for donors)
const getDonationsWithRequests = async (req, res) => {
  try {
    const user = req.user;
    const donor_id = user.role === "admin" ? null : user.id;

    const donations = await Donation.findWithPendingRequests(donor_id);

    res.status(200).json({
      success: true,
      data: { donations },
    });
  } catch (error) {
    console.error("Get donations with requests error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get donations with requests",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get donation statistics
const getDonationStats = async (req, res) => {
  try {
    const stats = await Donation.getStats();

    res.status(200).json({
      success: true,
      data: { stats },
    });
  } catch (error) {
    console.error("Get donation stats error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get donation statistics",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

module.exports = {
  getDonations,
  getDonationById,
  createDonation,
  updateDonation,
  deleteDonation,
  getMyDonations,
  getDonationsWithRequests,
  getDonationStats,
};
