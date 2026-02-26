package postgres

import (
	"example.com/internal/domain"
	"gorm.io/gorm"
)

type TaskStorage struct {
	db *gorm.DB
}

func NewTaskStorage(db *gorm.DB) *TaskStorage {
	return &TaskStorage{db: db}
}

func (s *TaskStorage) Create(task *domain.Task) error {
	return s.db.Create(task).Error
}

func (s *TaskStorage) GetByID(id int) (*domain.Task, error) {
	var task domain.Task
	if err := s.db.First(&task, id).Error; err != nil {
		return nil, err
	}
	return &task, nil
}

func (s *TaskStorage) GetAll() ([]*domain.Task, error) {
	var tasks []*domain.Task
	if err := s.db.Find(&tasks).Error; err != nil {
		return nil, err
	}
	return tasks, nil
}

func (s *TaskStorage) GetByCardID(cardID int) ([]*domain.Task, error) {
	var tasks []*domain.Task
	if err := s.db.Where("card_id = ?", cardID).Find(&tasks).Error; err != nil {
		return nil, err
	}
	return tasks, nil
}

func (s *TaskStorage) Update(task *domain.Task) error {
	return s.db.Save(task).Error
}

func (s *TaskStorage) UpdateName(id int, name *string) error {
	return s.db.Model(&domain.Task{}).Where("id = ?", id).Update("name", name).Error
}

func (s *TaskStorage) UpdateCompleted(id int, completed bool) error {
	return s.db.Model(&domain.Task{}).Where("id = ?", id).Update("completed", completed).Error
}

func (s *TaskStorage) Delete(id int) error {
	result := s.db.Delete(&domain.Task{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return nil
}

func (s *TaskStorage) DeleteByCardID(cardID int) error {
	return s.db.Where("card_id = ?", cardID).Delete(&domain.Task{}).Error
}
