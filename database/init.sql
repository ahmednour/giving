-- Giving Bridge Database Schema
-- MySQL Database Initialization Script

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS giving_bridge;
USE giving_bridge;

-- Set charset and collation
SET NAMES utf8mb4;
SET character_set_client = utf8mb4;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('donor', 'receiver', 'admin') NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    address TEXT DEFAULT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_active (is_active),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create donations table
CREATE TABLE IF NOT EXISTS donations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    image_url VARCHAR(500) DEFAULT NULL,
    category ENUM('food', 'clothing', 'electronics', 'books', 'furniture', 'other') DEFAULT 'other',
    donor_id INT NOT NULL,
    status ENUM('available', 'requested', 'donated') DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (donor_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_donor_id (donor_id),
    INDEX idx_status (status),
    INDEX idx_category (category),
    INDEX idx_created_at (created_at),
    FULLTEXT idx_search (title, description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create requests table
CREATE TABLE IF NOT EXISTS requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donation_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message TEXT DEFAULT NULL,
    status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending',
    admin_notes TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (donation_id) REFERENCES donations(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_donation_id (donation_id),
    INDEX idx_receiver_id (receiver_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    
    -- Ensure a receiver can only have one active request per donation
    UNIQUE KEY unique_active_request (donation_id, receiver_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create admin user (password: admin123)
-- Note: This is for development only. Change in production!
INSERT INTO users (name, email, password, role) VALUES 
('System Administrator', 'admin@givingbridge.com', '$2a$10$W0A14XUXi.5ykKSgXOSD8OOsVod3NvG5bH0pNVMMkZJ12fSukpOym', 'admin')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Create sample donor users
INSERT INTO users (name, email, password, role, phone, address) VALUES 
('John Donor', 'john@example.com', '$2a$10$W0A14XUXi.5ykKSgXOSD8OOsVod3NvG5bH0pNVMMkZJ12fSukpOym', 'donor', '+1234567890', '123 Main St, City, State'),
('Sarah Giver', 'sarah@example.com', '$2a$10$W0A14XUXi.5ykKSgXOSD8OOsVod3NvG5bH0pNVMMkZJ12fSukpOym', 'donor', '+1234567891', '456 Oak Ave, City, State')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Create sample receiver users
INSERT INTO users (name, email, password, role, phone, address) VALUES 
('Jane Receiver', 'jane@example.com', '$2a$10$W0A14XUXi.5ykKSgXOSD8OOsVod3NvG5bH0pNVMMkZJ12fSukpOym', 'receiver', '+1234567892', '789 Pine St, City, State'),
('Mary Receiver', 'mary@example.com', '$2a$10$W0A14XUXi.5ykKSgXOSD8OOsVod3NvG5bH0pNVMMkZJ12fSukpOym', 'receiver', '+1234567892', '789 Pine St, City, State'),
('David Need', 'david@example.com', '$2a$10$W0A14XUXi.5ykKSgXOSD8OOsVod3NvG5bH0pNVMMkZJ12fSukpOym', 'receiver', '+1234567893', '321 Elm St, City, State')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Create sample donations
INSERT INTO donations (title, description, category, donor_id, status) VALUES 
('Winter Clothes for Family', 'Gently used winter jackets, pants, and sweaters for a family of 4. All in good condition.', 'clothing', (SELECT id FROM users WHERE email = 'john@example.com'), 'available'),
('Children Books Collection', 'Collection of educational and story books for children ages 5-12. Perfect for learning and entertainment.', 'books', (SELECT id FROM users WHERE email = 'sarah@example.com'), 'available'),
('Kitchen Appliances Set', 'Complete set of kitchen appliances including microwave, toaster, and blender. All working perfectly.', 'electronics', (SELECT id FROM users WHERE email = 'john@example.com'), 'available'),
('Fresh Vegetables Box', 'Box of fresh organic vegetables from our garden. Includes tomatoes, carrots, lettuce, and more.', 'food', (SELECT id FROM users WHERE email = 'sarah@example.com'), 'available')
ON DUPLICATE KEY UPDATE title=VALUES(title);

-- Create sample requests
INSERT INTO requests (donation_id, receiver_id, message, status) VALUES 
((SELECT id FROM donations WHERE title = 'Winter Clothes for Family'), (SELECT id FROM users WHERE email = 'mary@example.com'), 'My family really needs winter clothes for the upcoming season. We would be very grateful.', 'pending'),
((SELECT id FROM donations WHERE title = 'Children Books Collection'), (SELECT id FROM users WHERE email = 'david@example.com'), 'These books would be perfect for my children to improve their reading skills.', 'approved')
ON DUPLICATE KEY UPDATE message=VALUES(message);

-- Create database views for common queries

-- View for donations with donor information
CREATE OR REPLACE VIEW v_donations_with_donors AS
SELECT 
    d.*,
    u.name AS donor_name,
    u.email AS donor_email,
    u.phone AS donor_phone
FROM donations d
JOIN users u ON d.donor_id = u.id
WHERE u.is_active = 1;

-- View for requests with complete information
CREATE OR REPLACE VIEW v_requests_complete AS
SELECT 
    r.*,
    d.title AS donation_title,
    d.description AS donation_description,
    d.image_url AS donation_image_url,
    d.category AS donation_category,
    donor.name AS donor_name,
    donor.email AS donor_email,
    receiver.name AS receiver_name,
    receiver.email AS receiver_email
FROM requests r
JOIN donations d ON r.donation_id = d.id
JOIN users donor ON d.donor_id = donor.id
JOIN users receiver ON r.receiver_id = receiver.id
WHERE donor.is_active = 1 AND receiver.is_active = 1;

-- Create stored procedures for common operations

DELIMITER //

-- Procedure to get user statistics
CREATE PROCEDURE GetUserStats(IN user_id INT)
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM donations WHERE donor_id = user_id) AS total_donations,
        (SELECT COUNT(*) FROM donations WHERE donor_id = user_id AND status = 'available') AS available_donations,
        (SELECT COUNT(*) FROM donations WHERE donor_id = user_id AND status = 'donated') AS completed_donations,
        (SELECT COUNT(*) FROM requests WHERE receiver_id = user_id) AS total_requests,
        (SELECT COUNT(*) FROM requests WHERE receiver_id = user_id AND status = 'pending') AS pending_requests,
        (SELECT COUNT(*) FROM requests WHERE receiver_id = user_id AND status = 'approved') AS approved_requests,
        (SELECT COUNT(*) FROM requests WHERE receiver_id = user_id AND status = 'completed') AS completed_requests;
END //

-- Procedure to get platform statistics
CREATE PROCEDURE GetPlatformStats()
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM users WHERE is_active = 1) AS total_users,
        (SELECT COUNT(*) FROM users WHERE role = 'donor' AND is_active = 1) AS total_donors,
        (SELECT COUNT(*) FROM users WHERE role = 'receiver' AND is_active = 1) AS total_receivers,
        (SELECT COUNT(*) FROM donations) AS total_donations,
        (SELECT COUNT(*) FROM donations WHERE status = 'available') AS available_donations,
        (SELECT COUNT(*) FROM donations WHERE status = 'donated') AS completed_donations,
        (SELECT COUNT(*) FROM requests) AS total_requests,
        (SELECT COUNT(*) FROM requests WHERE status = 'pending') AS pending_requests,
        (SELECT COUNT(*) FROM requests WHERE status = 'completed') AS completed_requests;
END //

DELIMITER ;

-- Create triggers for audit logging (optional)

-- Trigger to update donation status when request is approved
DELIMITER //

CREATE TRIGGER update_donation_on_request_approval
AFTER UPDATE ON requests
FOR EACH ROW
BEGIN
    IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
        UPDATE donations SET status = 'requested' WHERE id = NEW.donation_id;
    ELSEIF NEW.status = 'completed' AND OLD.status != 'completed' THEN
        UPDATE donations SET status = 'donated' WHERE id = NEW.donation_id;
    ELSEIF NEW.status = 'rejected' AND OLD.status = 'pending' THEN
        -- Check if there are other pending requests
        IF (SELECT COUNT(*) FROM requests WHERE donation_id = NEW.donation_id AND status = 'pending') = 0 THEN
            UPDATE donations SET status = 'available' WHERE id = NEW.donation_id;
        END IF;
    END IF;
END //

DELIMITER ;

-- Optimize database performance
OPTIMIZE TABLE users;
OPTIMIZE TABLE donations;
OPTIMIZE TABLE requests;

-- Display database information
SELECT 'Database initialization completed successfully!' AS message;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_donations FROM donations;
SELECT COUNT(*) AS total_requests FROM requests;
