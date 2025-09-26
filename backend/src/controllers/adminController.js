const User = require("../models/User");
const Donation = require("../models/Donation");
const Request = require("../models/Request");

// Get all users (admin only)
const getAllUsers = async (req, res) => {
  try {
    const { page = 1, limit = 50 } = req.query;

    const offset = (parseInt(page) - 1) * parseInt(limit);

    const users = await User.findAll(parseInt(limit), offset);

    res.status(200).json({
      success: true,
      data: {
        users: users.map((user) => user.toSafeObject()),
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: users.length,
        },
      },
    });
  } catch (error) {
    console.error("Get all users error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get users",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get user by ID (admin only)
const getUserById = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    // Get user statistics
    const stats = await User.getStats(user.id);

    res.status(200).json({
      success: true,
      data: {
        user: user.toSafeObject(),
        stats,
      },
    });
  } catch (error) {
    console.error("Get user by ID error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get user",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Deactivate user account (admin only)
const deactivateUser = async (req, res) => {
  try {
    const { id } = req.params;

    // Prevent admin from deactivating themselves
    if (parseInt(id) === req.user.id) {
      return res.status(400).json({
        success: false,
        message: "You cannot deactivate your own account",
      });
    }

    await User.deactivate(id);

    res.status(200).json({
      success: true,
      message: "User account deactivated successfully",
    });
  } catch (error) {
    console.error("Deactivate user error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to deactivate user account",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get all donations (admin only)
const getAllDonations = async (req, res) => {
  try {
    const { page = 1, limit = 50, status, category, search } = req.query;

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
    console.error("Get all donations error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get donations",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get all requests (admin only)
const getAllRequests = async (req, res) => {
  try {
    const { page = 1, limit = 50, status } = req.query;

    const offset = (parseInt(page) - 1) * parseInt(limit);

    const options = {
      limit: parseInt(limit),
      offset,
      status,
    };

    const requests = await Request.findAll(options);

    res.status(200).json({
      success: true,
      data: {
        requests,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: requests.length,
        },
      },
    });
  } catch (error) {
    console.error("Get all requests error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get requests",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get pending requests for review (admin only)
const getPendingRequests = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;

    const offset = (parseInt(page) - 1) * parseInt(limit);

    const requests = await Request.findPending(parseInt(limit), offset);

    res.status(200).json({
      success: true,
      data: {
        requests,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total: requests.length,
        },
      },
    });
  } catch (error) {
    console.error("Get pending requests error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get pending requests",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Approve or reject request (admin only)
const reviewRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, admin_notes } = req.body;

    // Validate status
    const validStatuses = ["approved", "rejected"];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid status. Must be "approved" or "rejected"',
      });
    }

    const updatedRequest = await Request.updateStatus(
      id,
      status,
      admin_notes,
      "admin"
    );

    res.status(200).json({
      success: true,
      message: `Request ${status} successfully`,
      data: { request: updatedRequest },
    });
  } catch (error) {
    console.error("Review request error:", error);

    if (error.message === "Request not found") {
      return res.status(404).json({
        success: false,
        message: "Request not found",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to review request",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Get platform statistics (admin only)
const getPlatformStats = async (req, res) => {
  try {
    // Get all statistics in parallel
    const [donationStats, requestStats] = await Promise.all([
      Donation.getStats(),
      Request.getStats(),
    ]);

    // Get user count
    const users = await User.findAll(1000, 0); // Get up to 1000 users for count
    const userCount = users.length;

    // Calculate success rate
    const successRate =
      requestStats.total_requests > 0
        ? (
            (requestStats.completed_requests / requestStats.total_requests) *
            100
          ).toFixed(2)
        : 0;

    const stats = {
      users: {
        total: userCount,
        donors: users.filter((u) => u.role === "donor").length,
        receivers: users.filter((u) => u.role === "receiver").length,
        admins: users.filter((u) => u.role === "admin").length,
      },
      donations: donationStats.overview,
      requests: requestStats,
      categories: donationStats.categories,
      metrics: {
        success_rate: parseFloat(successRate),
        average_donations_per_donor:
          donationStats.overview.total_donors > 0
            ? (
                donationStats.overview.total_donations /
                donationStats.overview.total_donors
              ).toFixed(2)
            : 0,
        average_requests_per_receiver:
          requestStats.total_receivers > 0
            ? (
                requestStats.total_requests / requestStats.total_receivers
              ).toFixed(2)
            : 0,
      },
    };

    res.status(200).json({
      success: true,
      data: { stats },
    });
  } catch (error) {
    console.error("Get platform stats error:", error);
    res.status(500).json({
      success: false,
      message: "Failed to get platform statistics",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Delete donation (admin only)
const deleteDonation = async (req, res) => {
  try {
    const { id } = req.params;

    await Donation.delete(id); // No donor_id restriction for admin

    res.status(200).json({
      success: true,
      message: "Donation deleted successfully",
    });
  } catch (error) {
    console.error("Delete donation error:", error);

    if (error.message === "Donation not found or access denied") {
      return res.status(404).json({
        success: false,
        message: "Donation not found",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to delete donation",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

// Delete request (admin only)
const deleteRequest = async (req, res) => {
  try {
    const { id } = req.params;

    await Request.delete(id); // No receiver_id restriction for admin

    res.status(200).json({
      success: true,
      message: "Request deleted successfully",
    });
  } catch (error) {
    console.error("Delete request error:", error);

    if (error.message === "Request not found or access denied") {
      return res.status(404).json({
        success: false,
        message: "Request not found",
      });
    }

    res.status(500).json({
      success: false,
      message: "Failed to delete request",
      error: process.env.NODE_ENV === "development" ? error.message : undefined,
    });
  }
};

module.exports = {
  getAllUsers,
  getUserById,
  deactivateUser,
  getAllDonations,
  getAllRequests,
  getPendingRequests,
  reviewRequest,
  getPlatformStats,
  deleteDonation,
  deleteRequest,
};
