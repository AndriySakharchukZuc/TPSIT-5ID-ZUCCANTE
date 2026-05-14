package main

import (
	"log"

	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/config"
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/db"
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/handlers"
	dbpostgres "github.com/AndriySakharchukZuc/microservice-api/group-service/internal/repo/postgres"
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/services"
	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.Load()

	database := db.NewDatabase(cfg.DatabaseURL)

	groupRepo := dbpostgres.NewGroupRepository(database.DB)
	groupMemberRepo := dbpostgres.NewGroupMemberRepository(database.DB)

	groupService := services.NewGroupService(groupRepo, groupMemberRepo)
	groupMemberService := services.NewGroupMemberService(groupMemberRepo)

	groupHandler := handlers.NewGroupHandler(groupService)
	groupMemberHandler := handlers.NewGroupMemberHandler(groupMemberService)

	r := gin.Default()

	v1 := r.Group("/api/v1")
	{
		v1.POST("/groups", groupHandler.Create)
		v1.GET("/groups", groupHandler.GetAll)
		v1.POST("/groups/join", groupHandler.Join)

		v1.GET("/groups/:id/members", groupMemberHandler.GetByGroup)
		v1.DELETE("/groups/:id/members/:userId", groupMemberHandler.Remove)
	}

	log.Printf("group-service starting on port %s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}
