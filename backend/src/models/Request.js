const { promisePool } = require("../config/database");

class Request {
  constructor(data) {
    this.id = data.id;
    this.donation_id = data.donation_id;
    this.receiver_id = data.receiver_id;
    this.message = data.message;
    this.status = data.status;
    this.admin_notes = data.admin_notes;
    this.created_at = data.created_at;
    this.updated_at = data.updated_at;

    // Include donation information if available
    if (data.donation_title) {
      this.donation = {
        id: data.donation_id,
        title: data.donation_title,
        description: data.donation_description,
        image_url: data.donation_image_url,
        category: data.donation_category,
        donor_id: data.donor_id,
        donor_name: data.donor_name,
      };
    }

    // Include receiver information if available
    if (data.receiver_name) {
      this.receiver = {
        id: data.receiver_id,
        name: data.receiver_name,
        email: data.receiver_email,
      };
    }
  }

  // Create a new request
  static async create(requestData) {
    try {
      const { donation_id, receiver_id, message } = requestData;

      // Check if donation exists and is available
      const [donations] = await promisePool.execute(
        'SELECT * FROM donations WHERE id = ? AND status = "available"',
        [donation_id]
      );

      if (donations.length === 0) {
        throw new Error("Donation not found or not available");
      }

      // Check if user already has a pending request for this donation
      const [existingRequests] = await promisePool.execute(
        'SELECT * FROM requests WHERE donation_id = ? AND receiver_id = ? AND status IN ("pending", "approved")',
        [donation_id, receiver_id]
      );

      if (existingRequests.length > 0) {
        throw new Error("You already have a pending request for this donation");
      }

      const [result] = await promisePool.execute(
        `INSERT INTO requests (donation_id, receiver_id, message, status, created_at, updated_at) 
         VALUES (?, ?, ?, 'pending', NOW(), NOW())`,
        [donation_id, receiver_id, message || null]
      );

      // Update donation status to 'requested'
      await promisePool.execute(
        'UPDATE donations SET status = "requested", updated_at = NOW() WHERE id = ?',
        [donation_id]
      );

      return await Request.findById(result.insertId);
    } catch (error) {
      throw error;
    }
  }

  // Find request by ID
  static async findById(id) {
    try {
      const [rows] = await promisePool.execute(
        `SELECT r.*, 
                d.title as donation_title, d.description as donation_description,
                d.image_url as donation_image_url, d.category as donation_category,
                d.donor_id, u1.name as donor_name,
                u2.name as receiver_name, u2.email as receiver_email
         FROM requests r
         JOIN donations d ON r.donation_id = d.id
         JOIN users u1 ON d.donor_id = u1.id
         JOIN users u2 ON r.receiver_id = u2.id
         WHERE r.id = ?`,
        [id]
      );

      if (rows.length === 0) {
        return null;
      }

      return new Request(rows[0]);
    } catch (error) {
      throw error;
    }
  }

  // Get all requests with pagination and filters
  static async findAll(options = {}) {
    try {
      const {
        limit = 20,
        offset = 0,
        status = null,
        receiver_id = null,
        donor_id = null,
      } = options;

      let query = `
        SELECT r.*, 
               d.title as donation_title, d.description as donation_description,
               d.image_url as donation_image_url, d.category as donation_category,
               d.donor_id, u1.name as donor_name,
               u2.name as receiver_name, u2.email as receiver_email
        FROM requests r
        JOIN donations d ON r.donation_id = d.id
        JOIN users u1 ON d.donor_id = u1.id
        JOIN users u2 ON r.receiver_id = u2.id
        WHERE 1=1
      `;
      const params = [];

      // Add filters
      if (status) {
        query += " AND r.status = ?";
        params.push(status);
      }

      if (receiver_id) {
        query += " AND r.receiver_id = ?";
        params.push(receiver_id);
      }

      if (donor_id) {
        query += " AND d.donor_id = ?";
        params.push(donor_id);
      }

      query += " ORDER BY r.created_at DESC LIMIT ? OFFSET ?";
      params.push(limit, offset);

      const [rows] = await promisePool.execute(query, params);

      return rows.map((row) => new Request(row));
    } catch (error) {
      throw error;
    }
  }

  // Get requests by receiver
  static async findByReceiver(receiver_id, limit = 20, offset = 0) {
    try {
      const [rows] = await promisePool.execute(
        `SELECT r.*, 
                d.title as donation_title, d.description as donation_description,
                d.image_url as donation_image_url, d.category as donation_category,
                d.donor_id, u1.name as donor_name,
                u2.name as receiver_name, u2.email as receiver_email
         FROM requests r
         JOIN donations d ON r.donation_id = d.id
         JOIN users u1 ON d.donor_id = u1.id
         JOIN users u2 ON r.receiver_id = u2.id
         WHERE r.receiver_id = ?
         ORDER BY r.created_at DESC 
         LIMIT ? OFFSET ?`,
        [receiver_id, limit, offset]
      );

      return rows.map((row) => new Request(row));
    } catch (error) {
      throw error;
    }
  }

  // Get requests for donor's donations
  static async findByDonor(donor_id, limit = 20, offset = 0) {
    try {
      const [rows] = await promisePool.execute(
        `SELECT r.*, 
                d.title as donation_title, d.description as donation_description,
                d.image_url as donation_image_url, d.category as donation_category,
                d.donor_id, u1.name as donor_name,
                u2.name as receiver_name, u2.email as receiver_email
         FROM requests r
         JOIN donations d ON r.donation_id = d.id
         JOIN users u1 ON d.donor_id = u1.id
         JOIN users u2 ON r.receiver_id = u2.id
         WHERE d.donor_id = ?
         ORDER BY r.created_at DESC 
         LIMIT ? OFFSET ?`,
        [donor_id, limit, offset]
      );

      return rows.map((row) => new Request(row));
    } catch (error) {
      throw error;
    }
  }

  // Update request status
  static async updateStatus(
    id,
    status,
    admin_notes = null,
    updater_role = null
  ) {
    try {
      // Validate status transitions
      const validStatuses = ["pending", "approved", "rejected", "completed"];
      if (!validStatuses.includes(status)) {
        throw new Error("Invalid status");
      }

      const [result] = await promisePool.execute(
        "UPDATE requests SET status = ?, admin_notes = ?, updated_at = NOW() WHERE id = ?",
        [status, admin_notes, id]
      );

      if (result.affectedRows === 0) {
        throw new Error("Request not found");
      }

      // Update donation status based on request status
      const request = await Request.findById(id);
      if (request) {
        let donationStatus;

        switch (status) {
          case "approved":
            donationStatus = "requested";
            break;
          case "completed":
            donationStatus = "donated";
            break;
          case "rejected":
            // Check if there are other pending requests
            const [pendingRequests] = await promisePool.execute(
              'SELECT COUNT(*) as count FROM requests WHERE donation_id = ? AND status = "pending"',
              [request.donation_id]
            );
            donationStatus =
              pendingRequests[0].count > 0 ? "requested" : "available";
            break;
          default:
            donationStatus = null;
        }

        if (donationStatus) {
          await promisePool.execute(
            "UPDATE donations SET status = ?, updated_at = NOW() WHERE id = ?",
            [donationStatus, request.donation_id]
          );
        }
      }

      return await Request.findById(id);
    } catch (error) {
      throw error;
    }
  }

  // Delete request
  static async delete(id, receiver_id = null) {
    try {
      // Get request details before deletion
      const request = await Request.findById(id);
      if (!request) {
        throw new Error("Request not found");
      }

      let query = "DELETE FROM requests WHERE id = ?";
      const params = [id];

      // If receiver_id is provided, ensure only the receiver can delete their request
      if (receiver_id) {
        query += " AND receiver_id = ?";
        params.push(receiver_id);
      }

      const [result] = await promisePool.execute(query, params);

      if (result.affectedRows === 0) {
        throw new Error("Request not found or access denied");
      }

      // Update donation status if this was the only pending request
      const [pendingRequests] = await promisePool.execute(
        'SELECT COUNT(*) as count FROM requests WHERE donation_id = ? AND status = "pending"',
        [request.donation_id]
      );

      if (pendingRequests[0].count === 0) {
        await promisePool.execute(
          'UPDATE donations SET status = "available", updated_at = NOW() WHERE id = ?',
          [request.donation_id]
        );
      }

      return true;
    } catch (error) {
      throw error;
    }
  }

  // Get request statistics
  static async getStats() {
    try {
      const [stats] = await promisePool.execute(
        `SELECT 
           COUNT(*) as total_requests,
           COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_requests,
           COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_requests,
           COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejected_requests,
           COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_requests,
           COUNT(DISTINCT receiver_id) as total_receivers
         FROM requests`
      );

      return stats[0];
    } catch (error) {
      throw error;
    }
  }

  // Get pending requests for admin review
  static async findPending(limit = 20, offset = 0) {
    try {
      const [rows] = await promisePool.execute(
        `SELECT r.*, 
                d.title as donation_title, d.description as donation_description,
                d.image_url as donation_image_url, d.category as donation_category,
                d.donor_id, u1.name as donor_name,
                u2.name as receiver_name, u2.email as receiver_email
         FROM requests r
         JOIN donations d ON r.donation_id = d.id
         JOIN users u1 ON d.donor_id = u1.id
         JOIN users u2 ON r.receiver_id = u2.id
         WHERE r.status = 'pending'
         ORDER BY r.created_at ASC 
         LIMIT ? OFFSET ?`,
        [limit, offset]
      );

      return rows.map((row) => new Request(row));
    } catch (error) {
      throw error;
    }
  }
}

module.exports = Request;
