package router

import (
	"zadanko/internal/handlers"
	"zadanko/internal/middleware"

	"github.com/gin-gonic/gin"
)

func Setup(
	r *gin.Engine,
	authHandler *handlers.AuthHandler,
	groupHandler *handlers.GroupHandler,
	groupMemberHandler *handlers.GroupMemberHandler,
	taskHandler *handlers.TaskHandler,
	jwtSecret string,
) {

	auth := r.Group("/auth")
	{
		auth.POST("/register", authHandler.Register)
		auth.POST("/login", authHandler.Login)
	}

	api := r.Group("/")
	api.Use(middleware.AuthMiddleware(jwtSecret))
	{
		api.POST("/users/fcm-token", authHandler.RegisterFCMToken)

		api.POST("/groups", groupHandler.Create)
		api.GET("/groups", groupHandler.GetAll)
		api.POST("/groups/join", groupHandler.Join)
		api.POST("/groups/:id/members", groupMemberHandler.Add)
		api.GET("/groups/:id/members", groupMemberHandler.GetByGroup)
		api.DELETE("/groups/:id/members/:userId", groupMemberHandler.Remove)

		api.POST("/groups/:id/tasks", taskHandler.Create)
		api.GET("/groups/:id/tasks", taskHandler.GetByGroup)
		api.PATCH("/tasks/:id", taskHandler.Update)
		api.DELETE("/tasks/:id", taskHandler.Delete)
	}
}
