package postgres

import (
	"example.com/internal/domain"
	"gorm.io/gorm"
)

type CardStorage struct {
	db *gorm.DB
}

func NewCardStorage(db *gorm.DB) *CardStorage {
	return &CardStorage{db: db}
}

func (s *CardStorage) Create(card *domain.Card) error {
	return s.db.Create(card).Error
}

func (s *CardStorage) GetByID(id int) (*domain.Card, error) {
	var card domain.Card
	if err := s.db.First(&card, id).Error; err != nil {
		return nil, err
	}
	return &card, nil
}

func (s *CardStorage) GetAll() ([]*domain.Card, error) {
	var cards []*domain.Card
	if err := s.db.Find(&cards).Error; err != nil {
		return nil, err
	}
	return cards, nil
}

func (s *CardStorage) Update(card *domain.Card) error {
	return s.db.Save(card).Error
}

func (s *CardStorage) UpdateTitle(id int, title *string) error {
	return s.db.Model(&domain.Card{}).Where("id = ?", id).Update("title", title).Error
}

func (s *CardStorage) Delete(id int) error {
	result := s.db.Delete(&domain.Card{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return nil
}
