package db

import (
	"log"

	"github.com/AndriySakharchukZuc/microservice-api/auth-service/internal/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Database struct {
	DB *gorm.DB
}

func NewDatabase(dsn string) *Database {
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed to connect to db: %v", err)
	}
	err = db.AutoMigrate(
		&models.User{},
	)
	if err != nil {
		log.Fatalf("failed to migrate: %v", err)
	}

	return &Database{DB: db}
}
