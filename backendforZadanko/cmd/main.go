package main

import (
	"zadanko/internal/config"
	"zadanko/internal/db"
	postgresrepo "zadanko/internal/db/postgres"
	"zadanko/internal/handlers"
	"zadanko/internal/router"
	"zadanko/internal/services"

	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.Load()

	database := db.NewDatabase(cfg.DatabaseURL)

	userRepo := postgresrepo.NewUserRepository(database.DB)
	fcmRepo := postgresrepo.NewFcmRepository(database.DB)
	groupRepo := postgresrepo.NewGroupRepository(database.DB)
	groupMemberRepo := postgresrepo.NewGroupMemberRepository(database.DB)
	taskRepo := postgresrepo.NewTaskRepository(database.DB)

	fcmService := services.NewFcmService(fcmRepo, groupMemberRepo, cfg.FirebaseCreds)
	authService := services.NewAuthService(userRepo, cfg.JWTSecret)
	groupService := services.NewGroupService(groupRepo, groupMemberRepo)
	groupMemberService := services.NewGroupMemberService(groupMemberRepo)
	taskService := services.NewTaskService(taskRepo, groupMemberRepo, fcmService)

	authHandler := handlers.NewAuthHandler(authService, fcmService)
	groupHandler := handlers.NewGroupHandler(groupService)
	groupMemberHandler := handlers.NewGroupMemberHandler(groupMemberService)
	taskHandler := handlers.NewTaskHandler(taskService)

	r := gin.Default()

	router.Setup(r, authHandler, groupHandler, groupMemberHandler, taskHandler, cfg.JWTSecret)

	r.Run(":" + cfg.Port)
}
