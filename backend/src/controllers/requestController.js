const Request = require("../models/Request");
const Donation = require("../models/Donation");
const Notification = require("../models/Notification");
const asyncHandler = require("../middleware/asyncHandler");
const ErrorResponse = require("../utils/errorResponse");

// @desc    Get all requests
// @route   GET /api/requests
// @access  Private
exports.getRequests = asyncHandler(async (req, res, next) => {
  // This logic can be expanded based on roles
  const requests = await Request.findAll(); // Simplified for now
  res.status(200).json({
    success: true,
    count: requests.length,
    data: requests,
  });
});

// @desc    Get single request
// @route   GET /api/requests/:id
// @access  Private
exports.getRequestById = asyncHandler(async (req, res, next) => {
  const request = await Request.findById(req.params.id);
  if (!request) {
    return next(
      new ErrorResponse(`Request not found with id of ${req.params.id}`, 404)
    );
  }
  // Add authorization checks if necessary
  res.status(200).json({ success: true, data: request });
});

// @desc    Get requests for the current user
// @route   GET /api/requests/my
// @access  Private (Receiver only)
exports.getMyRequests = asyncHandler(async (req, res, next) => {
  const requests = await Request.findByReceiver(req.user.id);
  res.status(200).json({
    success: true,
    count: requests.length,
    data: requests,
  });
});

// @desc    Create a new request for a donation
// @route   POST /api/requests
// @access  Private (Receiver only)
exports.createRequest = asyncHandler(async (req, res, next) => {
  req.body.receiver_id = req.user.id;

  const { donation_id } = req.body;

  // Find the donation to get the donor's ID
  const donation = await Donation.findById(donation_id);
  if (!donation) {
    return next(
      new ErrorResponse(`Donation not found with id of ${donation_id}`, 404)
    );
  }

  const request = await Request.create(req.body);

  // Create a notification for the donor
  const message = `${req.user.name} has requested your donation: "${donation.title}"`;
  await Notification.create(donation.donor_id, message);

  res.status(201).json({
    success: true,
    data: request,
  });
});

// @desc    Update request status
// @route   PUT /api/requests/:id/status
// @access  Private (Admin or Donor)
exports.updateRequestStatus = asyncHandler(async (req, res, next) => {
  const { status } = req.body;
  const requestId = req.params.id;

  const request = await Request.findById(requestId);

  if (!request) {
    return next(
      new ErrorResponse(`Request not found with id of ${requestId}`, 404)
    );
  }

  // Ensure user is either an Admin or the owner of the donation
  const donation = await Donation.findById(request.donation_id);
  if (req.user.role !== "ADMIN" && req.user.id !== donation.donor_id) {
    return next(
      new ErrorResponse(
        `User ${req.user.id} is not authorized to update this request`,
        401
      )
    );
  }

  const updatedRequest = await Request.updateStatus(requestId, status);

  // Create a notification for the receiver
  const message = `The status of your request for "${donation.title}" has been updated to ${status}.`;
  await Notification.create(request.receiver_id, message);

  res.status(200).json({
    success: true,
    data: updatedRequest,
  });
});

// @desc    Delete a request
// @route   DELETE /api/requests/:id
// @access  Private
exports.deleteRequest = asyncHandler(async (req, res, next) => {
  const request = await Request.findById(req.params.id);

  if (!request) {
    return next(
      new ErrorResponse(`Request not found with id of ${req.params.id}`, 404)
    );
  }

  // Make sure user is the request owner or an admin
  if (request.receiver_id !== req.user.id && req.user.role !== "ADMIN") {
    return next(
      new ErrorResponse(
        `User ${req.user.id} is not authorized to delete this request`,
        401
      )
    );
  }

  await Request.delete(req.params.id);

  res.status(200).json({
    success: true,
    data: {},
  });
});

// @desc    Get request statistics
// @route   GET /api/requests/stats
// @access  Private (Admin)
exports.getRequestStats = asyncHandler(async (req, res, next) => {
  const stats = await Request.getStats();
  res.status(200).json({
    success: true,
    stats,
  });
});
