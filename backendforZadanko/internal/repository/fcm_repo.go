package repository

import "zadanko/internal/entity"

type FcmRepository interface {
	Create(fcmToken *entity.FcmToken) error
	GetByUserID(userID string) ([]*entity.FcmToken, error)
}
