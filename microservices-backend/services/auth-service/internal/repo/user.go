package repository

import "github.com/AndriySakharchukZuc/microservice-api/auth-service/internal/models"

type UserRepository interface {
	Create(user *models.User) error
	GetByID(id string) (*models.User, error)
	GetByEmail(email string) (*models.User, error)
}
