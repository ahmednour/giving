const User = require("../models/User");
const ErrorResponse = require("../utils/errorResponse");
const asyncHandler = require("../middleware/asyncHandler");

// @desc      Update user details
// @route     PUT /api/users/profile
// @access    Private
exports.updateProfile = asyncHandler(async (req, res, next) => {
  const user = await User.findById(req.user.id);

  if (user) {
    user.name = req.body.name || user.name;
    user.email = req.body.email || user.email;

    // In a real app, you'd send a confirmation email if the email changes.

    const updatedUser = await User.updateProfile(req.user.id, {
      name: user.name,
      email: user.email,
    });
    res.status(200).json({
      success: true,
      data: updatedUser,
    });
  } else {
    return next(new ErrorResponse("User not found", 404));
  }
});

// @desc      Change user password
// @route     PUT /api/users/password
// @access    Private
exports.changePassword = asyncHandler(async (req, res, next) => {
  // In a real app, you would implement logic to change the password
  res.status(200).json({
    success: true,
    data: "Password updated successfully (placeholder)",
  });
});

// @desc      Deactivate user account
// @route     DELETE /api/users/account
// @access    Private
exports.deactivateAccount = asyncHandler(async (req, res, next) => {
  await User.deactivate(req.user.id);
  res.status(200).json({
    success: true,
    data: "Account deactivated successfully",
  });
});

// @desc      Get user stats
// @route     GET /api/users/stats
// @access    Private
exports.getUserStats = asyncHandler(async (req, res, next) => {
  const stats = await User.getStats(req.user.id);
  res.status(200).json({
    success: true,
    data: stats,
  });
});
