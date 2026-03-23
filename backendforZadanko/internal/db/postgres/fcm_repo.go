package postgres

import (
	"zadanko/internal/entity"

	"gorm.io/gorm"
)

type fcmRepository struct {
	db *gorm.DB
}

func NewFcmRepository(db *gorm.DB) *fcmRepository {
	return &fcmRepository{db: db}
}

func (r *fcmRepository) Create(fcmToken *entity.FcmToken) error {
	return r.db.Create(fcmToken).Error
}

func (r *fcmRepository) GetByUserID(userID string) ([]*entity.FcmToken, error) {
	var tokens []*entity.FcmToken
	err := r.db.Where("user_id = ?", userID).Find(&tokens).Error
	return tokens, err
}
