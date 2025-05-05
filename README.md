# Spring Boot Security with JWT Authentication

This project demonstrates how to implement JWT (JSON Web Token) authentication in a Spring Boot application. It provides a secure way to handle user authentication and authorization using JWT tokens.

## Table of Contents
- [Features](#features)
- [Project Structure](#project-structure)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [API Endpoints](#api-endpoints)
- [How It Works](#how-it-works)
- [Security Flow](#security-flow)
- [Testing the Application](#testing-the-application)

## Features
- User registration and login
- Role-based authorization (USER and ADMIN roles)
- JWT token-based authentication
- Password encryption
- Cross-Origin Resource Sharing (CORS) enabled
- RESTful API endpoints

## Project Structure
```
src/main/java/com/example/springsecurityjwt/
├── controller/           # REST controllers
├── dto/                  # Data Transfer Objects
├── entity/              # JPA entities
├── repository/          # JPA repositories
├── security/            # Security configuration and JWT utilities
│   └── jwt/            # JWT related classes
├── service/             # Business logic layer
│   └── impl/           # Service implementations
└── SpringSecurityJwtApplication.java
```

## Technology Stack
- Java 17
- Spring Boot 3.x
- Spring Security
- Spring Data JPA
- MySQL
- Maven
- JWT (JSON Web Token)
- Lombok

## Getting Started

### Prerequisites
- Java 17 or higher
- Maven
- MySQL

### Database Configuration
1. Create a MySQL database
2. Update `application.properties` with your database credentials:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/your_database
spring.datasource.username=your_username
spring.datasource.password=your_password
```

### Running the Application
1. Clone the repository
2. Navigate to the project directory
3. Run the application:
```bash
mvn spring-boot:run
```

## API Endpoints

### Authentication Endpoints
- `POST /api/auth/signup` - Register a new user
  ```json
  {
    "username": "user",
    "email": "user@example.com",
    "password": "password",
    "role": ["user"]
  }
  ```

- `POST /api/auth/signin` - Login
  ```json
  {
    "username": "user",
    "password": "password"
  }
  ```

### Protected Endpoints
- `GET /api/test/user` - Accessible by authenticated users
- `GET /api/test/admin` - Accessible by users with ADMIN role

## How It Works

### 1. User Registration
When a user registers:
1. The request is received by `AuthController`
2. `AuthService` validates the request
3. Password is encrypted using `PasswordEncoder`
4. User roles are assigned
5. User is saved to the database

### 2. User Authentication
When a user logs in:
1. `AuthController` receives the login request
2. `AuthService` authenticates the user
3. If successful, a JWT token is generated
4. The token is returned to the client

### 3. Protected Resource Access
When accessing protected resources:
1. Client includes JWT token in the Authorization header
2. `JwtAuthenticationFilter` intercepts the request
3. Token is validated
4. User details are loaded
5. Access is granted or denied based on user roles

## Security Flow

### JWT Token Generation
1. User submits credentials
2. Server validates credentials
3. Server generates JWT token containing:
   - User information
   - Roles
   - Expiration time
4. Token is signed with a secret key

### JWT Token Validation
1. Client includes token in requests
2. Server validates token signature
3. Server checks token expiration
4. Server extracts user information
5. Server authorizes the request

## Testing the Application

### 1. Register a User
```bash
curl -X POST http://localhost:8080/api/auth/signup \
-H "Content-Type: application/json" \
-d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123",
    "role": ["user"]
}'
```

### 2. Login
```bash
curl -X POST http://localhost:8080/api/auth/signin \
-H "Content-Type: application/json" \
-d '{
    "username": "testuser",
    "password": "password123"
}'
```

### 3. Access Protected Resource
```bash
curl -X GET http://localhost:8080/api/test/user \
-H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Key Components

### Security Configuration
- `WebSecurityConfig`: Configures security rules and authentication
- `JwtAuthenticationFilter`: Intercepts requests to validate JWT tokens
- `UserDetailsServiceImpl`: Loads user-specific data
- `JwtUtils`: Handles JWT token generation and validation

### Service Layer
- `AuthService`: Handles authentication and registration
- `UserService`: Manages user-related operations

### Data Layer
- `User`: JPA entity representing users
- `Role`: JPA entity representing user roles
- `UserRepository`: Handles user data persistence
- `RoleRepository`: Handles role data persistence

## Best Practices Implemented
1. Separation of concerns (Controller, Service, Repository layers)
2. Password encryption
3. JWT token-based authentication
4. Role-based authorization
5. Proper error handling
6. Clean code structure
7. RESTful API design

## Common Issues and Solutions
1. **Token Expiration**: Tokens expire after a configured time. Users need to re-authenticate.
2. **CORS Issues**: The application is configured to handle CORS requests.
3. **Role Assignment**: Users can be assigned multiple roles during registration.

## Contributing
Feel free to submit issues and enhancement requests! 