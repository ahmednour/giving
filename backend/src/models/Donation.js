const { promisePool } = require("../config/database");

class Donation {
  constructor(data) {
    this.id = data.id;
    this.title = data.title;
    this.description = data.description;
    this.image_url = data.image_url;
    this.category = data.category;
    this.donor_id = data.donor_id;
    this.status = data.status;
    this.created_at = data.created_at;
    this.updated_at = data.updated_at;

    // Include donor information if available
    if (data.donor_name) {
      this.donor = {
        id: data.donor_id,
        name: data.donor_name,
        email: data.donor_email,
      };
    }
  }

  // Create a new donation
  static async create(donationData) {
    try {
      const { title, description, image_url, category, donor_id } =
        donationData;

      const [result] = await promisePool.execute(
        `INSERT INTO donations (title, description, image_url, category, donor_id, status, created_at, updated_at) 
         VALUES (?, ?, ?, ?, ?, 'available', NOW(), NOW())`,
        [title, description, image_url || null, category || "other", donor_id]
      );

      return await Donation.findById(result.insertId);
    } catch (error) {
      throw error;
    }
  }

  // Find donation by ID
  static async findById(id) {
    try {
      const [rows] = await promisePool.execute(
        `SELECT d.*, u.name as donor_name, u.email as donor_email 
         FROM donations d 
         JOIN users u ON d.donor_id = u.id 
         WHERE d.id = ?`,
        [id]
      );

      if (rows.length === 0) {
        return null;
      }

      return new Donation(rows[0]);
    } catch (error) {
      throw error;
    }
  }

  // Get all donations with pagination and filters
  static async findAll(options = {}) {
    try {
      const {
        limit = 20,
        offset = 0,
        status = null,
        category = null,
        donor_id = null,
        search = null,
      } = options;

      let query = `SELECT d.*, u.name as donor_name, u.email as donor_email FROM donations d JOIN users u ON d.donor_id = u.id WHERE 1=1`;
      const params = [];

      // Add filters
      if (status) {
        query += " AND d.status = ?";
        params.push(status);
      }

      if (category) {
        query += " AND d.category = ?";
        params.push(category);
      }

      if (donor_id) {
        query += " AND d.donor_id = ?";
        params.push(donor_id);
      }

      if (search) {
        query += " AND (d.title LIKE ? OR d.description LIKE ?)";
        params.push(`%${search}%`, `%${search}%`);
      }

      query += ` ORDER BY d.created_at DESC LIMIT ${parseInt(
        limit
      )} OFFSET ${parseInt(offset)}`;

      const [rows] = await promisePool.query(query, params);

      return rows.map((row) => new Donation(row));
    } catch (error) {
      throw error;
    }
  }

  // Get donations by donor
  static async findByDonor(donorId, { page = 1, limit = 10 }) {
    try {
      const offset = (page - 1) * limit;
      const query = `SELECT d.*, u.name as donor_name, u.email as donor_email 
         FROM donations d 
         JOIN users u ON d.donor_id = u.id 
         WHERE d.donor_id = ? 
         ORDER BY d.created_at DESC 
         LIMIT ? OFFSET ?`;

      const [rows] = await promisePool.query(query, [
        donorId,
        parseInt(limit),
        parseInt(offset),
      ]);

      const countQuery =
        "SELECT COUNT(*) as count FROM donations WHERE donor_id = ?";
      const [countRows] = await promisePool.execute(countQuery, [donorId]);

      return {
        donations: rows,
        totalPages: Math.ceil(countRows[0].count / limit),
        currentPage: page,
      };
    } catch (error) {
      console.error("Error finding donations by donor:", error);
      throw error;
    }
  }

  // Update donation
  static async update(id, updateData, donor_id = null) {
    try {
      const fields = [];
      const values = [];

      const allowedFields = [
        "title",
        "description",
        "image_url",
        "category",
        "status",
      ];

      allowedFields.forEach((field) => {
        if (updateData[field] !== undefined) {
          fields.push(`${field} = ?`);
          values.push(updateData[field]);
        }
      });

      if (fields.length === 0) {
        throw new Error("No valid fields to update");
      }

      fields.push("updated_at = NOW()");

      let query = `UPDATE donations SET ${fields.join(", ")} WHERE id = ?`;
      values.push(id);

      // If donor_id is provided, ensure only the donor can update their donation
      if (donor_id) {
        query += " AND donor_id = ?";
        values.push(donor_id);
      }

      const [result] = await promisePool.execute(query, values);

      if (result.affectedRows === 0) {
        throw new Error("Donation not found or access denied");
      }

      return await Donation.findById(id);
    } catch (error) {
      throw error;
    }
  }

  // Delete donation
  static async delete(id, donor_id = null) {
    try {
      let query = "DELETE FROM donations WHERE id = ?";
      const params = [id];

      // If donor_id is provided, ensure only the donor can delete their donation
      if (donor_id) {
        query += " AND donor_id = ?";
        params.push(donor_id);
      }

      const [result] = await promisePool.execute(query, params);

      if (result.affectedRows === 0) {
        throw new Error("Donation not found or access denied");
      }

      return true;
    } catch (error) {
      throw error;
    }
  }

  // Get donation statistics
  static async getStats() {
    try {
      const [stats] = await promisePool.execute(
        `SELECT 
           COUNT(*) as total_donations,
           COUNT(CASE WHEN status = 'available' THEN 1 END) as available_donations,
           COUNT(CASE WHEN status = 'requested' THEN 1 END) as requested_donations,
           COUNT(CASE WHEN status = 'donated' THEN 1 END) as completed_donations,
           COUNT(DISTINCT donor_id) as total_donors
         FROM donations`
      );

      const [categoryStats] = await promisePool.execute(
        `SELECT category, COUNT(*) as count 
         FROM donations 
         GROUP BY category 
         ORDER BY count DESC`
      );

      return {
        overview: stats[0],
        categories: categoryStats,
      };
    } catch (error) {
      throw error;
    }
  }

  // Get donations with pending requests
  static async findWithPendingRequests(donor_id = null) {
    try {
      let query = `
        SELECT DISTINCT d.*, u.name as donor_name, u.email as donor_email,
               COUNT(r.id) as pending_requests_count
        FROM donations d 
        JOIN users u ON d.donor_id = u.id 
        JOIN requests r ON d.id = r.donation_id 
        WHERE r.status = 'pending'
      `;
      const params = [];

      if (donor_id) {
        query += " AND d.donor_id = ?";
        params.push(donor_id);
      }

      query += " GROUP BY d.id ORDER BY d.created_at DESC";

      const [rows] = await promisePool.execute(query, params);

      return rows.map((row) => new Donation(row));
    } catch (error) {
      throw error;
    }
  }

  // Update donation status when request is approved/completed
  static async updateStatus(id, status) {
    try {
      const [result] = await promisePool.execute(
        "UPDATE donations SET status = ?, updated_at = NOW() WHERE id = ?",
        [status, id]
      );

      if (result.affectedRows === 0) {
        throw new Error("Donation not found");
      }

      return await Donation.findById(id);
    } catch (error) {
      throw error;
    }
  }
}

module.exports = Donation;
