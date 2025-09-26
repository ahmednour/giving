const Joi = require("joi");

// Generic validation middleware
const validate = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body);

    if (error) {
      const errorMessage = error.details[0].message;
      return res.status(400).json({
        success: false,
        message: "Validation error",
        details: errorMessage,
      });
    }

    next();
  };
};

// User registration validation
const registerSchema = Joi.object({
  name: Joi.string().min(2).max(100).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).max(128).required(),
  role: Joi.string().valid("donor", "receiver").required(),
});

// User login validation
const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

// Donation creation validation
const donationSchema = Joi.object({
  title: Joi.string().min(3).max(200).required(),
  description: Joi.string().min(10).max(1000).required(),
  image_url: Joi.string().uri().optional().allow(""),
  category: Joi.string()
    .valid("food", "clothing", "electronics", "books", "furniture", "other")
    .optional(),
});

// Donation update validation
const donationUpdateSchema = Joi.object({
  title: Joi.string().min(3).max(200).optional(),
  description: Joi.string().min(10).max(1000).optional(),
  image_url: Joi.string().uri().optional().allow(""),
  status: Joi.string().valid("available", "requested", "donated").optional(),
  category: Joi.string()
    .valid("food", "clothing", "electronics", "books", "furniture", "other")
    .optional(),
});

// Request creation validation
const requestSchema = Joi.object({
  donation_id: Joi.number().integer().positive().required(),
  message: Joi.string().min(10).max(500).optional(),
});

// Request status update validation
const requestUpdateSchema = Joi.object({
  status: Joi.string()
    .valid("pending", "approved", "rejected", "completed")
    .required(),
});

// Profile update validation
const profileUpdateSchema = Joi.object({
  name: Joi.string().min(2).max(100).optional(),
  email: Joi.string().email().optional(),
  phone: Joi.string()
    .pattern(/^[+]?[\d\s\-\(\)]+$/)
    .optional()
    .allow(""),
  address: Joi.string().max(500).optional().allow(""),
});

// Password change validation
const passwordChangeSchema = Joi.object({
  currentPassword: Joi.string().required(),
  newPassword: Joi.string().min(6).max(128).required(),
});

module.exports = {
  validate,
  validateRegister: validate(registerSchema),
  validateLogin: validate(loginSchema),
  validateDonation: validate(donationSchema),
  validateDonationUpdate: validate(donationUpdateSchema),
  validateRequest: validate(requestSchema),
  validateRequestUpdate: validate(requestUpdateSchema),
  validateProfileUpdate: validate(profileUpdateSchema),
  validatePasswordChange: validate(passwordChangeSchema),
};
