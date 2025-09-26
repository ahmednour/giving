# Giving Bridge - Donation & Community Help App

A comprehensive donation and community help platform that connects donors and receivers.

## 🚀 Features

- **User Authentication**: JWT-based authentication with role management (Donor, Receiver, Admin)
- **Donation Management**: Donors can create and manage donation listings
- **Request Management**: Receivers can request donations and track status
- **Profile Management**: Users can view their donations and requests
- **Admin Panel**: Review and approve requests, manage users
- **Cross-Platform**: Works on Web & Mobile via Flutter
- **Containerized**: Fully dockerized for easy deployment

## 🏗️ Tech Stack

- **Frontend**: Flutter (Web & Mobile)
- **Backend**: Node.js + Express.js
- **Database**: MySQL
- **Authentication**: JWT
- **Deployment**: Docker + Docker Compose

## 📁 Project Structure

```
giving-bridge/
├── backend/                 # Node.js + Express API
│   ├── src/
│   │   ├── controllers/     # Route controllers
│   │   ├── middleware/      # Authentication & validation
│   │   ├── models/         # Database models
│   │   ├── routes/         # API routes
│   │   └── config/         # Database & app configuration
│   ├── package.json
│   └── Dockerfile
├── frontend/               # Flutter application
│   ├── lib/
│   │   ├── screens/        # UI screens
│   │   ├── services/       # API services
│   │   ├── models/         # Data models
│   │   └── widgets/        # Reusable widgets
│   ├── pubspec.yaml
│   └── Dockerfile
├── database/               # MySQL schema
│   └── init.sql
├── scripts/                # Deployment scripts
│   └── deploy.sh
├── docker-compose.yml      # Production setup
├── docker-compose.dev.yml  # Development setup
└── README.md
```

## 🚀 Quick Start with Docker

### Option 1: Using Deployment Script (Recommended)

```bash
# Make script executable (Linux/Mac)
chmod +x scripts/deploy.sh

# Start production environment
./scripts/deploy.sh start

# Start development environment
./scripts/deploy.sh dev

# View logs
./scripts/deploy.sh logs

# Stop services
./scripts/deploy.sh stop
```

### Option 2: Manual Docker Commands

```bash
# Production
docker-compose up --build -d

# Development (includes phpMyAdmin)
docker-compose -f docker-compose.dev.yml up --build -d
```

## 🌐 Access Points

### Production Mode

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000/api
- **Database**: localhost:3307

### Development Mode

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:8000/api
- **Database**: localhost:3307
- **phpMyAdmin**: http://localhost:8080

## 👥 Demo Accounts

The application comes with pre-configured demo accounts:

| Role     | Email                  | Password | Description           |
| -------- | ---------------------- | -------- | --------------------- |
| Admin    | admin@givingbridge.com | admin123 | Full platform access  |
| Donor    | john@example.com       | admin123 | Can create donations  |
| Donor    | sarah@example.com      | admin123 | Can create donations  |
| Receiver | mary@example.com       | admin123 | Can request donations |
| Receiver | david@example.com      | admin123 | Can request donations |

## 📊 Database Schema

### Core Tables

- **USERS**: User accounts with role-based access
- **DONATIONS**: Donation listings created by donors
- **REQUESTS**: Donation requests from receivers

### Key Features

- Foreign key relationships for data integrity
- Indexes for optimal performance
- Triggers for automatic status updates
- Views for complex queries
- Stored procedures for statistics

## 🔐 User Roles & Permissions

### Donor

- Create and manage donation listings
- View and respond to requests for their donations
- Update donation status
- View platform statistics

### Receiver

- Browse available donations
- Create requests for needed items
- Track request status
- View request history

### Admin

- Manage all users and donations
- Review and approve/reject requests
- View comprehensive platform analytics
- Access admin dashboard

## 🛠️ Development Setup

### Prerequisites

- Node.js 18+ (for backend development)
- Flutter 3.0+ (for frontend development)
- Docker & Docker Compose (for containerized development)
- MySQL 8.0+ (for local database development)

### Backend Development

```bash
cd backend
npm install
npm run dev
```

### Frontend Development

```bash
cd frontend
flutter pub get
flutter run -d web
```

### Local Database Setup

```bash
mysql -u root -p < database/init.sql
```

## 📝 API Documentation

### Authentication Endpoints

- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get user profile
- `POST /api/auth/refresh` - Refresh JWT token
- `POST /api/auth/logout` - User logout

### Donation Endpoints

- `GET /api/donations` - Get all donations (with filters)
- `GET /api/donations/:id` - Get donation details
- `POST /api/donations` - Create donation (Donor only)
- `PUT /api/donations/:id` - Update donation
- `DELETE /api/donations/:id` - Delete donation
- `GET /api/donations/my/donations` - Get user's donations
- `GET /api/donations/stats` - Get donation statistics

### Request Endpoints

- `GET /api/requests` - Get user requests
- `GET /api/requests/:id` - Get request details
- `POST /api/requests` - Create request (Receiver only)
- `PUT /api/requests/:id/status` - Update request status
- `DELETE /api/requests/:id` - Delete request
- `GET /api/requests/my/requests` - Get user's requests
- `GET /api/requests/stats` - Get request statistics

### User Management Endpoints

- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update profile
- `PUT /api/users/password` - Change password
- `GET /api/users/stats` - Get user statistics

### Admin Endpoints

- `GET /api/admin/users` - Get all users
- `GET /api/admin/donations` - Get all donations
- `GET /api/admin/requests` - Get all requests
- `GET /api/admin/requests/pending` - Get pending requests
- `PUT /api/admin/requests/:id/review` - Review request
- `GET /api/admin/stats` - Get platform statistics

## 🐳 Docker Configuration

### Production Environment

- Optimized for performance and security
- Multi-stage builds for smaller images
- Health checks for all services
- Automatic restarts on failure

### Development Environment

- Volume mounts for hot reloading
- Additional debugging tools
- phpMyAdmin for database management
- Detailed logging

### Commands

```bash
# Production
docker-compose up --build -d
docker-compose logs -f
docker-compose down

# Development
docker-compose -f docker-compose.dev.yml up --build -d
docker-compose -f docker-compose.dev.yml logs -f
docker-compose -f docker-compose.dev.yml down

# Cleanup
docker-compose down --volumes --rmi all
docker system prune -a
```

## 🚀 Production Deployment

### Environment Variables

Create a `.env` file with production values:

```env
NODE_ENV=production
DB_HOST=your-database-host
DB_USER=your-database-user
DB_PASSWORD=your-secure-password
JWT_SECRET=your-super-secure-jwt-secret
FRONTEND_URL=https://your-domain.com
```

### Security Considerations

1. Change default database passwords
2. Use strong JWT secrets
3. Configure SSL/TLS certificates
4. Set up proper firewall rules
5. Enable database encryption
6. Implement rate limiting
7. Set up monitoring and alerting

### Scaling

- Use container orchestration (Kubernetes, Docker Swarm)
- Implement horizontal scaling for backend
- Use CDN for frontend assets
- Configure database replication
- Implement caching layers (Redis)

## 📈 Monitoring & Logging

### Health Checks

All services include health check endpoints:

- Backend: `GET /api/health`
- Frontend: Available via nginx
- Database: MySQL ping

### Logging

- Structured JSON logging in production
- Log rotation and retention policies
- Centralized logging with ELK stack (optional)

## 🔧 Troubleshooting

### Common Issues

1. **Database Connection Failed**

   ```bash
   # Check if MySQL is running
   docker-compose ps

   # View database logs
   docker-compose logs mysql-db
   ```

2. **Frontend Not Loading**

   ```bash
   # Check if backend is accessible
   curl http://localhost:8000/api/health

   # Rebuild frontend
   docker-compose build frontend
   ```

3. **API Errors**

   ```bash
   # View backend logs
   docker-compose logs backend

   # Check database connectivity
   docker-compose exec backend node -e "require('./src/config/database').testConnection()"
   ```

### Performance Optimization

- Enable MySQL query cache
- Implement database indexing
- Use Flutter web optimizations
- Configure nginx caching
- Implement API response caching

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### Development Guidelines

- Follow ESLint rules for JavaScript
- Use Dart formatting for Flutter code
- Write unit tests for new features
- Update documentation for API changes
- Follow semantic versioning

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

- Create an issue for bug reports
- Use discussions for feature requests
- Contact maintainers for security issues

## 🎯 Future Enhancements

- Mobile app deployment (iOS/Android)
- Real-time notifications
- Geolocation-based matching
- Image upload functionality
- Multi-language support
- Social media integration
- Advanced analytics dashboard
- API rate limiting
- Email notification system
