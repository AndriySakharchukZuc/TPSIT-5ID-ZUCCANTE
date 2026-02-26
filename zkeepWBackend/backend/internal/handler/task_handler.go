package handler

import (
	"net/http"
	"strconv"

	"example.com/internal/domain"
	"example.com/internal/storage"
	"github.com/gin-gonic/gin"
)

type TaskHandler struct {
	storage storage.TaskStorage
}

func NewTaskHandler(storage storage.TaskStorage) *TaskHandler {
	return &TaskHandler{storage: storage}
}

type createTaskInput struct {
	Name   string `json:"name"`
	CardID int    `json:"card_id"`
}

type updateTaskInput struct {
	Name      *string `json:"name"`
	Completed *bool   `json:"completed"`
}

func (h *TaskHandler) CreateTask(c *gin.Context) {
	var input createTaskInput
	if err := c.ShouldBindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	task := &domain.Task{
		Name:      &input.Name,
		CardID:    input.CardID,
		Completed: false,
	}

	if err := h.storage.Create(task); err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, task)
}

func (h *TaskHandler) GetAllTasks(c *gin.Context) {
	tasks, err := h.storage.GetAll()
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(http.StatusOK, tasks)
}

func (h *TaskHandler) GetTask(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid ID param")
		return
	}

	task, err := h.storage.GetByID(id)
	if err != nil {
		newErrorResponse(c, http.StatusNotFound, "task not found")
		return
	}

	c.JSON(http.StatusOK, task)
}

func (h *TaskHandler) UpdateTask(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid ID param")
		return
	}

	var input updateTaskInput
	if err := c.ShouldBindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	task, err := h.storage.GetByID(id)
	if err != nil {
		newErrorResponse(c, http.StatusNotFound, "task not found")
		return
	}

	if input.Name != nil {
		task.Name = input.Name
	}
	if input.Completed != nil {
		task.Completed = *input.Completed
	}

	if err := h.storage.Update(task); err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, task)
}

func (h *TaskHandler) ToggleTaskCompleted(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid id param")
		return
	}

	task, err := h.storage.GetByID(id)
	if err != nil {
		newErrorResponse(c, http.StatusNotFound, "task not found")
		return
	}

	newStatus := !task.Completed

	if err := h.storage.UpdateCompleted(id, newStatus); err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, statusResponse{Status: "toggled"})
}

func (h *TaskHandler) DeleteTask(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid id param")
		return
	}

	if err := h.storage.Delete(id); err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, statusResponse{Status: "deleted"})
}

func (h *TaskHandler) GetCardTasks(c *gin.Context) {
	cardID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid card id")
		return
	}

	tasks, err := h.storage.GetByCardID(cardID)
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, tasks)
}
