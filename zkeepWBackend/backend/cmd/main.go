package main

import (
	"fmt"
	"log"

	"example.com/internal/cfg"
	"example.com/internal/handler"
	"example.com/internal/storage"
	"example.com/internal/storage/postgres"
)

func main() {
	cfg, err := cfg.Load()
	if err != nil {
		log.Fatalf("fatal error: %v", err)
	}

	db, err := postgres.NewConnection(cfg.Database)
	if err != nil {
		log.Fatal("failed to connect to database:", err)
	}

	if err := postgres.RunMigrations(db); err != nil {
		log.Fatal("failed to run migrations:", err)
	}

	var cardStorage storage.CardStorage = postgres.NewCardStorage(db)
	var taskStorage storage.TaskStorage = postgres.NewTaskStorage(db)

	router := handler.SetupRouter(cardStorage, taskStorage)

	addr := fmt.Sprintf("%s:%s", cfg.Server.Host, cfg.Server.Port)
	log.Printf("server: %s", addr)

	if err := router.Run(addr); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
