package main

import (
	"log"

	"github.com/AndriySakharchukZuc/microservice-api/auth-service/internal/config"
	"github.com/AndriySakharchukZuc/microservice-api/auth-service/internal/db"
	"github.com/AndriySakharchukZuc/microservice-api/auth-service/internal/handlers"
	dbpostgres "github.com/AndriySakharchukZuc/microservice-api/auth-service/internal/repo/postgres"
	"github.com/AndriySakharchukZuc/microservice-api/auth-service/internal/services"
	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.Load()

	database := db.NewDatabase(cfg.DatabaseURL)

	userRepo := dbpostgres.NewUserRepo(database.DB)
	authService := services.NewAuthService(userRepo, cfg.JWTSecret)
	authHandler := handlers.NewAuthHandler(authService)

	r := gin.Default()

	v1 := r.Group("/api/v1")
	{
		v1.POST("/register", authHandler.Register)
		v1.POST("/login", authHandler.Login)
	}

	log.Printf("auth-service starting on port %s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}
