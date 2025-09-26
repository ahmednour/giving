# Giving Bridge Frontend

A modern, responsive web application built with Flutter Web for the Giving Bridge platform - connecting donors with those in need through a secure, transparent platform.

## 🌟 Features

- **Modern Design System**: Built with Material 3 design principles and custom theming
- **Responsive Layout**: Optimized for desktop, tablet, and mobile devices
- **Professional UI Components**: Web-like interface that doesn't look like a mobile app
- **Authentication System**: Complete login/register flow with form validation
- **Dashboard**: Comprehensive dashboard with stats, quick actions, and activity feeds
- **Settings Management**: User profile and preferences management
- **Theme Support**: Light/dark mode with system preference detection
- **Progressive Web App**: PWA capabilities with offline support
- **Accessibility**: Built with accessibility best practices

## 🏗️ Architecture

### Project Structure

```
frontend/
├── lib/
│   ├── components/           # Reusable UI components
│   │   ├── buttons/         # Custom button components
│   │   ├── forms/           # Form components (text fields, etc.)
│   │   ├── navigation/      # Navigation components (navbar, sidebar)
│   │   └── common/          # Common components (cards, loading, etc.)
│   ├── config/              # App configuration
│   │   └── app_router.dart  # GoRouter configuration
│   ├── pages/               # Application pages
│   │   ├── auth/           # Authentication pages
│   │   ├── dashboard/       # Dashboard pages
│   │   └── settings/        # Settings pages
│   ├── providers/           # State management (Provider pattern)
│   ├── theme/               # Theme configuration
│   │   ├── app_colors.dart  # Color system
│   │   ├── app_typography.dart # Typography system
│   │   └── app_theme.dart   # Theme configuration
│   ├── utils/               # Utility functions
│   │   └── responsive.dart  # Responsive utilities
│   └── main.dart           # App entry point
├── web/                     # Web-specific files
│   ├── index.html          # Main HTML file
│   └── manifest.json       # PWA manifest
├── assets/                  # Static assets
│   ├── images/             # Image assets
│   ├── icons/              # Icon assets
│   └── fonts/              # Font assets
└── pubspec.yaml            # Dependencies and configuration
```

### Key Technologies

- **Flutter Web**: Cross-platform framework for web development
- **Material 3**: Modern design system
- **GoRouter**: Declarative routing solution
- **Provider**: State management solution
- **Responsive Framework**: Responsive design utilities

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Web browser (Chrome recommended for development)
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd giving/frontend
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run -d chrome
   ```

### Development Scripts

- **Run in development mode**

  ```bash
  flutter run -d chrome --web-renderer canvaskit
  ```

- **Build for production**

  ```bash
  flutter build web --web-renderer canvaskit --release
  ```

- **Run tests**

  ```bash
  flutter test
  ```

- **Generate code (if using code generation)**
  ```bash
  flutter packages pub run build_runner build
  ```

## 🎨 Design System

### Colors

The application uses a comprehensive color system with support for both light and dark themes:

- **Primary**: Blue (#2563EB) - Main brand color
- **Secondary**: Emerald (#10B981) - Success and positive actions
- **Accent**: Violet (#8B5CF6) - Highlights and special elements
- **Status Colors**: Success, Warning, Error, Info variants

### Typography

Typography follows a hierarchical system with web-appropriate fonts:

- **Display**: Large headings and hero text (Poppins)
- **Headlines**: Page titles and section headers (Poppins)
- **Titles**: Component titles and labels (Inter)
- **Body**: Regular content text (Inter)

### Responsive Breakpoints

- **Mobile**: < 450px
- **Tablet**: 450px - 800px
- **Desktop**: 800px - 1920px
- **Ultra-wide**: > 1920px

## 🧩 Components

### Core Components

- **CustomButton**: Flexible button component with multiple variants
- **CustomTextField**: Form input with validation and theming
- **CustomCard**: Card component with elevation and interaction states
- **Navbar**: Top navigation with responsive behavior
- **Sidebar**: Collapsible sidebar navigation for dashboard
- **LoadingWidget**: Loading states and skeleton loaders

### Form Components

- Form validation with real-time feedback
- Consistent styling across all input types
- Accessibility features built-in

### Navigation Components

- Responsive navigation that adapts to screen size
- Smooth transitions and animations
- Breadcrumb support for deep navigation

## 📱 Pages

### Landing Page

- Hero section with compelling call-to-action
- Feature highlights
- Statistics and testimonials
- Responsive design across all devices

### Authentication

- **Login**: Email/password with social login options
- **Register**: Complete registration with validation
- Form validation and error handling
- Loading states and success feedback

### Dashboard

- Overview of user activity and stats
- Quick action cards
- Recent activity feed
- Responsive sidebar navigation

### Settings

- User profile management
- Notification preferences
- Privacy settings
- Theme selection
- Account management

## 🎯 State Management

The application uses the Provider pattern for state management:

- **AuthProvider**: User authentication and profile management
- **ThemeProvider**: Theme and appearance settings
- Local state management with setState for UI-specific state

## 🌐 Routing

Navigation is handled by GoRouter with:

- Declarative route configuration
- Route guards for authentication
- Smooth page transitions
- Deep linking support
- Error handling with custom error pages

## 🔧 Configuration

### Environment Setup

The application supports different environments through configuration:

- Development: Local development with hot reload
- Production: Optimized build for deployment

### Theme Configuration

Themes can be customized in `lib/theme/`:

- Colors: Modify `app_colors.dart`
- Typography: Update `app_typography.dart`
- Overall theme: Configure `app_theme.dart`

## 📦 Deployment

### Web Deployment

1. **Build the application**

   ```bash
   flutter build web --web-renderer canvaskit --release
   ```

2. **Deploy the `build/web` directory** to your web server or hosting platform

### Recommended Hosting Platforms

- **Firebase Hosting**: Easy integration with Firebase services
- **Netlify**: Great for static sites with CI/CD
- **Vercel**: Excellent performance and developer experience
- **GitHub Pages**: Free hosting for open source projects

## 🧪 Testing

The application includes comprehensive testing:

- **Unit Tests**: Core logic and utilities
- **Widget Tests**: Component behavior
- **Integration Tests**: End-to-end user flows

Run tests with:

```bash
flutter test
```

## 🔍 Performance

### Optimization Features

- **Code Splitting**: Lazy loading of routes
- **Image Optimization**: Efficient asset loading
- **Caching**: Aggressive caching strategies
- **Bundle Analysis**: Optimized bundle sizes

### Performance Monitoring

- Web Vitals tracking
- Performance metrics collection
- Error monitoring and reporting

## 🌍 Internationalization

The app is prepared for internationalization:

- Structured for easy translation addition
- RTL language support ready
- Date and number formatting

## 🔒 Security

Security considerations implemented:

- Input validation and sanitization
- Secure authentication flow
- XSS prevention
- HTTPS enforcement
- Content Security Policy

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent file structure

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:

- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🎉 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Open source community for the packages used

---

Built with ❤️ using Flutter Web
