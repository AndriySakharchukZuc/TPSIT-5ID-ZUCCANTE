package repository

import "zadanko/internal/entity"

type TaskRepository interface {
	Create(task *entity.Task) error
	GetByID(id string) (*entity.Task, error)
	GetByGroupID(groupID string) ([]*entity.Task, error)
	Update(task *entity.Task) error
	Delete(id string) error
}
