package postgres

import (
	"zadanko/internal/entity"

	"gorm.io/gorm"
)

type taskRepository struct {
	db *gorm.DB
}

func NewTaskRepository(db *gorm.DB) *taskRepository {
	return &taskRepository{db: db}
}

func (r *taskRepository) Create(task *entity.Task) error {
	return r.db.Create(task).Error
}

func (r *taskRepository) GetByID(id string) (*entity.Task, error) {
	var task entity.Task
	err := r.db.First(&task, "id = ?", id).Error
	return &task, err
}

func (r *taskRepository) GetByGroupID(groupID string) ([]*entity.Task, error) {
	var tasks []*entity.Task
	err := r.db.Where("group_id = ? AND is_deleted = false", groupID).Find(&tasks).Error
	return tasks, err
}

func (r *taskRepository) Update(task *entity.Task) error {
	return r.db.Save(task).Error
}

func (r *taskRepository) Delete(id string) error {
	return r.db.Model(&entity.Task{}).Where("id = ?", id).Update("is_deleted", true).Error
}
