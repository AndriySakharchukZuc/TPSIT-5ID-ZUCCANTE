# Zadanko Backend

A task management backend built with Go, featuring group collaboration and real-time push notifications.

## Tech Stack

- Language: Go (1.25.2+)
- Framework: Gin Gonic
- ORM: GORM
- Database: PostgreSQL
- Authentication: JWT (JSON Web Tokens)
- Push Notifications: Firebase Cloud Messaging (doesn't work)
- Containerization: Docker

## Features

- User Authentication: Secure registration and login using JWT.
- Group Management: Create groups, join existing ones, and manage group members.
- Task Management: Create, update, and track tasks within groups.
- Real-time Notifications: Automated push notifications via FCM for task updates and assignments.
- Clean Architecture: Organized into repository, service, and handler layers for maintainability.

## Project Structure

```text
├── cmd/                # Entry point (main.go)
├── internal/
│   ├── config/         # Configuration loading
│   ├── db/             # Database connection and migrations
│   ├── dto/            # Data Transfer Objects
│   ├── entity/         # Database models
│   ├── handlers/       # HTTP controllers
│   ├── middleware/     # Auth and other middlewares
│   ├── repository/     # Data access layer
│   ├── router/         # API route definitions
│   └── services/       # Business logic layer
└── docker-compose.yml  # Local development infrastructure
```

## Configuration

The application requires the following environment variables (.env):

| Variable                  | Description                           | Example                                                                          |
| ------------------------- | ------------------------------------- | -------------------------------------------------------------------------------- |
| PORT                      | Server port                           | 8080                                                                             |
| DATABASE_URL              | PostgreSQL connection string          | host=db user=postgres password=password dbname=zadanko port=5432 sslmode=disable |
| JWT_SECRET                | Secret key for JWT signing            | your_super_secret_key                                                            |
| FIREBASE_CREDENTIALS_PATH | Path to Firebase service account JSON | ./firebase-credentials.json                                                      |

## API Endpoints

### Authentication

- POST /auth/register - Register a new user
- POST /auth/login - Login and receive JWT

### User Settings

- POST /users/fcm-token - Register/Update FCM token (requires Auth)

### Groups

- POST /groups - Create a new group
- GET /groups - List all groups the user belongs to
- POST /groups/join - Join a group via code

### Group Members

- POST /groups/:id/members - Add a member to a group
- GET /groups/:id/members - List members of a group
- DELETE /groups/:id/members/:userId - Remove a member from a group

### Tasks

- POST /groups/:id/tasks - Create a task in a group
- GET /groups/:id/tasks - Get all tasks for a group
- PATCH /tasks/:id - Update task status/details
- DELETE /tasks/:id - Delete a task

## Running with Docker

1. Ensure you have a firebase-credentials.json file in the root directory.
2. Configure your .env file.
3. Start the services:
   ```bash
   docker-compose up --build
   ```
