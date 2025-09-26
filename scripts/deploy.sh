#!/bin/bash

# Giving Bridge - Deployment Script
# This script helps deploy the Giving Bridge application using Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed."
}

# Stop existing containers
stop_containers() {
    print_info "Stopping existing containers..."
    docker-compose down --remove-orphans || true
    docker-compose -f docker-compose.dev.yml down --remove-orphans || true
    print_success "Containers stopped."
}

# Build and start services
start_production() {
    print_info "Starting Giving Bridge in PRODUCTION mode..."
    
    # Build and start services
    docker-compose up --build -d
    
    print_success "Giving Bridge is starting up!"
    print_info "Services:"
    print_info "  - Frontend: http://localhost:3000"
    print_info "  - Backend API: http://localhost:8000"
    print_info "  - Database: localhost:3306"
    
    print_info "Waiting for services to be healthy..."
    sleep 10
    
    # Check service health
    if docker-compose ps | grep -q "healthy"; then
        print_success "All services are running!"
    else
        print_warning "Some services might still be starting up."
        print_info "Check logs with: docker-compose logs -f"
    fi
}

start_development() {
    print_info "Starting Giving Bridge in DEVELOPMENT mode..."
    
    # Build and start services
    docker-compose -f docker-compose.dev.yml up --build -d
    
    print_success "Giving Bridge development environment is starting up!"
    print_info "Services:"
    print_info "  - Frontend: http://localhost:3001"
    print_info "  - Backend API: http://localhost:8000"
    print_info "  - Database: localhost:3306"
    print_info "  - phpMyAdmin: http://localhost:8080"
    
    print_info "Waiting for services to be healthy..."
    sleep 10
    
    print_success "Development environment is ready!"
    print_info "Check logs with: docker-compose -f docker-compose.dev.yml logs -f"
}

# Show logs
show_logs() {
    if [ "$1" = "dev" ]; then
        docker-compose -f docker-compose.dev.yml logs -f
    else
        docker-compose logs -f
    fi
}

# Clean up
cleanup() {
    print_info "Cleaning up Docker resources..."
    
    # Stop containers
    stop_containers
    
    # Remove volumes (optional)
    read -p "Do you want to remove database volumes? This will DELETE ALL DATA! (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker volume rm giving_bridge_mysql_data 2>/dev/null || true
        docker volume rm giving_bridge_mysql_dev_data 2>/dev/null || true
        print_warning "Database volumes removed."
    fi
    
    # Remove images
    read -p "Do you want to remove Docker images? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down --rmi all || true
        docker-compose -f docker-compose.dev.yml down --rmi all || true
        print_info "Docker images removed."
    fi
    
    print_success "Cleanup completed."
}

# Show status
show_status() {
    print_info "Production services:"
    docker-compose ps
    
    print_info "Development services:"
    docker-compose -f docker-compose.dev.yml ps
}

# Main script
main() {
    echo "🌉 Giving Bridge - Deployment Script"
    echo "===================================="
    
    check_docker
    
    case "${1:-help}" in
        "start")
            stop_containers
            start_production
            ;;
        "dev")
            stop_containers
            start_development
            ;;
        "stop")
            stop_containers
            ;;
        "logs")
            show_logs "${2:-prod}"
            ;;
        "status")
            show_status
            ;;
        "cleanup")
            cleanup
            ;;
        "restart")
            stop_containers
            if [ "$2" = "dev" ]; then
                start_development
            else
                start_production
            fi
            ;;
        "help"|*)
            echo "Usage: $0 {start|dev|stop|logs|status|cleanup|restart|help}"
            echo ""
            echo "Commands:"
            echo "  start    - Start production environment"
            echo "  dev      - Start development environment"
            echo "  stop     - Stop all services"
            echo "  logs     - Show logs (add 'dev' for development logs)"
            echo "  status   - Show service status"
            echo "  cleanup  - Clean up Docker resources"
            echo "  restart  - Restart services (add 'dev' for development)"
            echo "  help     - Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 start          # Start production"
            echo "  $0 dev            # Start development"
            echo "  $0 logs dev       # Show development logs"
            echo "  $0 restart dev    # Restart development"
            ;;
    esac
}

# Run main function with all arguments
main "$@"
