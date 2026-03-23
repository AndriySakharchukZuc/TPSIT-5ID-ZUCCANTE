package db

import (
	"log"
	"zadanko/internal/entity"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Database struct {
	DB *gorm.DB
}

func NewDatabase(dsn string) *Database {
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed connect to DB: %v", err)
	}
	err = db.AutoMigrate(
		&entity.User{},
		&entity.FcmToken{},
		&entity.Group{},
		&entity.GroupMember{},
		&entity.Task{},
	)

	if err != nil {
		log.Fatalf("failed to migrate: %v", err)
	}
	return &Database{DB: db}
}
