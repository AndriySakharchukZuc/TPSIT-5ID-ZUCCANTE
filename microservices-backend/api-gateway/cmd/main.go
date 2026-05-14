package main

import (
	"log"

	"github.com/AndriySakharchukZuc/microservice-api/api-gateway/internal/config"
	"github.com/AndriySakharchukZuc/microservice-api/api-gateway/internal/middleware"
	"github.com/AndriySakharchukZuc/microservice-api/api-gateway/internal/proxy"
	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.Load()

	r := gin.Default()
	r.RedirectTrailingSlash = false
	r.RedirectFixedPath = false

	auth := r.Group("/api/v1/auth")
	{
		auth.Any("", proxy.To(cfg.AuthService))
		auth.Any("/*path", proxy.To(cfg.AuthService))
	}

	protected := r.Group("/api/v1")
	protected.Use(middleware.Auth(cfg.JWTSecret))
	{
		protected.Any("/groups", proxy.To(cfg.GroupService))
		protected.Any("/groups/*path", proxy.To(cfg.GroupService))
		protected.Any("/tasks", proxy.To(cfg.TaskService))
		protected.Any("/tasks/*path", proxy.To(cfg.TaskService))
	}

	log.Printf("api-gateway starting on port %s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}
