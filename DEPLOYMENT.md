# Deployment Guide - Giving Bridge

Complete deployment instructions for the Giving Bridge donation platform.

## Prerequisites

### System Requirements

- Docker Engine 20.10+
- Docker Compose 2.0+
- Minimum 4GB RAM
- 10GB available disk space

### Development Requirements (Optional)

- Node.js 18+
- Flutter 3.0+
- MySQL 8.0+

## Quick Deployment

### 1. Clone Repository

```bash
git clone <repository-url>
cd giving-bridge
```

### 2. Production Deployment

```bash
# Using deployment script (recommended)
chmod +x scripts/deploy.sh
./scripts/deploy.sh start

# Or using Docker Compose directly
docker-compose up --build -d
```

### 3. Access Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Database**: localhost:3307 (production) / localhost:3308 (development)

## Development Deployment

### Start Development Environment

```bash
# Using deployment script
./scripts/deploy.sh dev

# Or using Docker Compose directly
docker-compose -f docker-compose.dev.yml up --build -d
```

### Access Points

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:8000
- **Database**: localhost:3307 (production) / localhost:3308 (development)
- **phpMyAdmin**: http://localhost:8080

## Environment Configuration

### Production Environment Variables

Create a `.env` file in the project root:

```env
# Application
NODE_ENV=production
PORT=8000

# Database
DB_HOST=mysql-db
DB_USER=root
DB_PASSWORD=your-secure-password
DB_NAME=giving_bridge
DB_PORT=3306  # Internal container port (don't change)

# JWT
JWT_SECRET=your-super-secure-jwt-secret-key
JWT_EXPIRES_IN=24h
JWT_REFRESH_EXPIRES_IN=7d

# Frontend
FRONTEND_URL=http://localhost:3000
```

### Development Environment Variables

```env
# Application
NODE_ENV=development
PORT=8000

# Database
DB_HOST=mysql-db
DB_USER=root
DB_PASSWORD=password
DB_NAME=giving_bridge
DB_PORT=3306  # Internal container port (don't change)

# JWT
JWT_SECRET=dev-jwt-secret-key
JWT_EXPIRES_IN=24h
JWT_REFRESH_EXPIRES_IN=7d

# Frontend
FRONTEND_URL=http://localhost:3001
```

## Database Setup

### Automatic Setup

The database is automatically initialized with:

- Schema creation
- Sample data
- Demo user accounts
- Indexes and optimizations

### Manual Database Setup

If you need to set up the database manually:

```bash
# Connect to MySQL container
docker-compose exec mysql-db mysql -u root -p

# Run initialization script
mysql> source /docker-entrypoint-initdb.d/init.sql;
```

### Demo Accounts

| Role     | Email                  | Password |
| -------- | ---------------------- | -------- |
| Admin    | admin@givingbridge.com | admin123 |
| Donor    | john@example.com       | admin123 |
| Donor    | sarah@example.com      | admin123 |
| Receiver | mary@example.com       | admin123 |
| Receiver | david@example.com      | admin123 |

## Service Management

### Using Deployment Script

```bash
# Start services
./scripts/deploy.sh start

# Start development environment
./scripts/deploy.sh dev

# View logs
./scripts/deploy.sh logs

# View development logs
./scripts/deploy.sh logs dev

# Stop services
./scripts/deploy.sh stop

# Check status
./scripts/deploy.sh status

# Restart services
./scripts/deploy.sh restart

# Cleanup (removes containers, volumes, images)
./scripts/deploy.sh cleanup
```

### Using Docker Compose

```bash
# Production
docker-compose up -d                 # Start in background
docker-compose logs -f               # View logs
docker-compose ps                    # Check status
docker-compose down                  # Stop services
docker-compose down --volumes        # Stop and remove volumes

# Development
docker-compose -f docker-compose.dev.yml up -d
docker-compose -f docker-compose.dev.yml logs -f
docker-compose -f docker-compose.dev.yml down
```

## Health Checks

### Service Health Endpoints

- **Backend**: http://localhost:8000/api/health
- **Frontend**: http://localhost:3000 (or 3001 for dev)
- **Database**: Automatic MySQL ping

### Manual Health Checks

```bash
# Check all services
docker-compose ps

# Check specific service logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mysql-db

# Test backend API
curl http://localhost:8000/api/health

# Test database connection
docker-compose exec mysql-db mysql -u root -p -e "SELECT 1"
```

## Troubleshooting

### Common Issues

#### 1. Port Already in Use

```bash
# Check what's using the port
netstat -tlnp | grep :3000
netstat -tlnp | grep :8000
netstat -tlnp | grep :3307  # Production
netstat -tlnp | grep :3308  # Development

# Kill process using port
sudo kill -9 <PID>
```

#### 1.5. MySQL Port Conflicts

If you get a port conflict error for MySQL (port 3306), this means MySQL is already running locally on your machine.

**Solution 1: Use Different Ports (Recommended)**
The Docker Compose configurations are already set to use different ports:

- Production: `localhost:3307` → container `3306`
- Development: `localhost:3308` → container `3306`

**Solution 2: Stop Local MySQL (Temporary)**

```bash
# Windows
net stop mysql80  # or mysql57, mysql56 depending on version
sc query mysql80  # Check status

# Linux/macOS
sudo systemctl stop mysql
sudo systemctl status mysql
```

**Solution 3: Check what's using the port**

```bash
# Windows
netstat -ano | findstr :3306
tasklist /FI "PID eq <PID>"

# Linux/macOS
sudo lsof -i :3306
ps aux | grep <PID>
```

#### 2. Database Connection Issues

```bash
# Check MySQL container status
docker-compose logs mysql-db

# Restart database
docker-compose restart mysql-db

# Reset database
docker-compose down
docker volume rm giving_bridge_mysql_data
docker-compose up -d
```

#### 3. Backend API Errors

```bash
# Check backend logs
docker-compose logs backend

# Restart backend
docker-compose restart backend

# Check environment variables
docker-compose exec backend env
```

#### 4. Frontend Not Loading

```bash
# Check frontend logs
docker-compose logs frontend

# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend

# Clear browser cache
# Check browser developer console for errors
```

#### 5. Docker Build Issues

```bash
# Clean Docker cache
docker system prune -a

# Rebuild with no cache
docker-compose build --no-cache

# Check Docker daemon status
sudo systemctl status docker
```

### Performance Issues

#### 1. Slow Database Queries

```bash
# Check MySQL performance
docker-compose exec mysql-db mysql -u root -p -e "SHOW PROCESSLIST;"

# Enable slow query log
docker-compose exec mysql-db mysql -u root -p -e "SET GLOBAL slow_query_log = 'ON';"
```

#### 2. High Memory Usage

```bash
# Check container resource usage
docker stats

# Limit container memory
# Add to docker-compose.yml:
services:
  backend:
    deploy:
      resources:
        limits:
          memory: 512M
```

#### 3. Slow Frontend Loading

```bash
# Check nginx logs
docker-compose logs frontend

# Enable gzip compression (already configured)
# Use browser caching (already configured)
# Optimize Flutter build
```

## Security Hardening

### 1. Change Default Passwords

```bash
# Update MySQL root password
docker-compose exec mysql-db mysql -u root -p -e "ALTER USER 'root'@'%' IDENTIFIED BY 'new-secure-password';"

# Update application database password in .env file
```

### 2. Use Strong JWT Secret

```env
# Generate strong JWT secret
JWT_SECRET=$(openssl rand -base64 32)
```

### 3. Configure Firewall

```bash
# Ubuntu/Debian
sudo ufw allow 3000  # Frontend
sudo ufw allow 8000  # Backend
sudo ufw deny 3306   # Database (only local access)

# CentOS/RHEL
sudo firewall-cmd --add-port=3000/tcp --permanent
sudo firewall-cmd --add-port=8000/tcp --permanent
sudo firewall-cmd --reload
```

### 4. SSL/TLS Configuration

For production, configure SSL certificates:

```nginx
# Add to frontend/nginx.conf
server {
    listen 443 ssl;
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    # ... rest of configuration
}
```

## Backup and Recovery

### Database Backup

```bash
# Create backup
docker-compose exec mysql-db mysqldump -u root -p giving_bridge > backup.sql

# Restore from backup
docker-compose exec -T mysql-db mysql -u root -p giving_bridge < backup.sql
```

### Volume Backup

```bash
# Backup database volume
docker run --rm -v giving_bridge_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz /data

# Restore database volume
docker run --rm -v giving_bridge_mysql_data:/data -v $(pwd):/backup alpine tar xzf /backup/mysql_backup.tar.gz -C /
```

## Monitoring

### Log Management

```bash
# View real-time logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f backend

# View last 100 lines
docker-compose logs --tail=100

# Save logs to file
docker-compose logs > application.log
```

### Resource Monitoring

```bash
# Monitor container resources
docker stats

# Monitor system resources
htop
df -h
free -m
```

### Application Monitoring

```bash
# Check API endpoints
curl http://localhost:8000/api/health
curl http://localhost:8000/api/donations
curl http://localhost:8000/api/users/stats

# Monitor database
docker-compose exec mysql-db mysql -u root -p -e "SHOW STATUS;"
```

## Scaling

### Horizontal Scaling

```yaml
# Add to docker-compose.yml
services:
  backend:
    deploy:
      replicas: 3
    ports:
      - "8000-8002:8000"
```

### Load Balancer Configuration

```yaml
# Add nginx load balancer
services:
  load-balancer:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - backend
```

## CI/CD Integration

### GitHub Actions Example

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Deploy to server
        run: |
          ssh user@server 'cd /path/to/app && git pull && docker-compose up --build -d'
```

### Docker Registry

```bash
# Build and tag images
docker build -t your-registry/giving-bridge-backend:latest ./backend
docker build -t your-registry/giving-bridge-frontend:latest ./frontend

# Push to registry
docker push your-registry/giving-bridge-backend:latest
docker push your-registry/giving-bridge-frontend:latest
```

## Support

For deployment issues:

1. Check the logs: `docker-compose logs`
2. Verify environment variables
3. Check port availability
4. Review firewall settings
5. Create an issue in the repository

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Node.js Production Practices](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
