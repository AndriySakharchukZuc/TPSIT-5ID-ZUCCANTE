# zkeep

Flutter GoogleKeep like project

# How to use

## Running Docker image

For run backend should use in `backend\` directory:

```bash
docker compose up
```

## Backend config

All variables, such as `db_host`, `db_port`, `db_password`, etc. are configured in `docker-compose.yml`.

If any errors with docker postgres occur, alternative variables are defined in `backend\internal\cfg\cfg.go`

## Flutter app config

The IP address for the backend is hardcoded in `zkeep\lib\utils\api.dart` as:

```dart
  static const String baseUrl = 'http://192.168.1.4:8080/api';
```

If the IP address is different, it should be changed. For example:

```dart
  static const String baseUrl = 'http://your.ip.or.url:8080/api';
```

---

# Backend

Used Go with GORM for repositories and Gin as a HTTP framework.

### Database

The main database is PostgreSQL. GORM is used for interaction with the database. GORM is also used for creating and migrating tables.

Two tables for server databases are used: Cards and Tasks.

Table structures:

https://dbdiagram.io/e/69a71872a3f0aa31e1b08341/69a7197da3f0aa31e1b0a024

All interactions are defined in `backend\internal\storage\storage.go` interfaces, and in `backend\internal\storage\postgres` are the implementations of those interfaces.

### HTTP

In `backend\internal\handler`, all handlers and the router are implemented.

---

# Flutter app

### Models

Two models are used in the application:

- `models/card.dart` - represents a note card.
- `models/task.dart` - represents a task.

### Database

`db/helper.dart` contains a local database helper for the app. It's used for saving user notes inside the internal storage and not volatile one. The structure of tables is different than on backend side:

https://dbdiagram.io/e/69a7242fa3f0aa31e1b1c252/69a72543a3f0aa31e1b1e13e

### Utils

- `utils/api.dart` defines the `Api` class and all HTTP methods for communication with the backend (GET, POST, PATCH, PUT, DELETE)
- `utils/notifier.dart` implements state change for updating application on actions of user

### Widgets

- `widgets/task_card.dart` - widget that renders a single card and list of tasks.
- `widgets/task_item.dart` - widget that renders a single task inside a card.
