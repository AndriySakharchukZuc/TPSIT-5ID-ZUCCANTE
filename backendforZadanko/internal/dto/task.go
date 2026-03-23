package dto

import "time"

type CreateTaskRequest struct {
	ID          string     `json:"id"`
	AssignedTo  *string    `json:"assigned_to"`
	Title       string     `json:"title"`
	Description string     `json:"description"`
	DueAt       *time.Time `json:"due_at"`
}

type UpdateTaskRequest struct {
	Title       string     `json:"title"`
	Description string     `json:"description"`
	Status      string     `json:"status"`
	AssignedTo  *string    `json:"assigned_to"`
	DueAt       *time.Time `json:"due_at"`
}
