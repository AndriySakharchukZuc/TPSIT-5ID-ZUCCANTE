# Zadanko

## Features

- JWT Authentication: Secure login and registration system.
- Group Management: Create and view task groups.
- Task Tracking: Detailed task management within group contexts.
- Local Storage: SQLite integration for session and data persistence.
- Dynamic Configuration: Adjustable API endpoints via application settings.

## Technical Stack

- Database: sqflite (SQLite)
- Communication: http
- Security: jwt_decoder, uuid

## Directory Layout

- lib/api: Logic for backend service interaction.
- lib/db: Local database helpers and session management.
- lib/models: Data classes for users, groups, and tasks.
- lib/screens: UI implementations for the application flow.
