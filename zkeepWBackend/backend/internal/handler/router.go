package handler

import (
	"example.com/internal/storage"
	"github.com/gin-gonic/gin"
)

func SetupRouter(cardStorage storage.CardStorage, taskStorage storage.TaskStorage) *gin.Engine {
	router := gin.Default()

	v1 := router.Group("/api")
	{
		taskHandler := NewTaskHandler(taskStorage)
		cardHandler := NewCardHandler(cardStorage)

		cards := v1.Group("/cards")
		{
			cards.POST("", cardHandler.CreateCard)
			cards.GET("", cardHandler.GetAllCards)
			cards.GET("/:id", cardHandler.GetCard)
			cards.PUT("/:id", cardHandler.UpdateCard)
			cards.DELETE("/:id", cardHandler.DeleteCard)
			cards.GET("/:id/tasks", taskHandler.GetCardTasks)
		}

		tasks := v1.Group("/tasks")
		{
			tasks.POST("", taskHandler.CreateTask)
			tasks.GET("", taskHandler.GetAllTasks)
			tasks.GET("/:id", taskHandler.GetTask)
			tasks.PUT("/:id", taskHandler.UpdateTask)
			tasks.PATCH("/:id/toggle", taskHandler.ToggleTaskCompleted)
			tasks.DELETE("/:id", taskHandler.DeleteTask)
		}
	}

	return router
}
