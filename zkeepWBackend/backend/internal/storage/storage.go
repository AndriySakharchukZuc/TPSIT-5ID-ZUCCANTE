package storage

import "example.com/internal/domain"

type CardStorage interface {
	Create(card *domain.Card) error

	GetByID(id int) (*domain.Card, error)

	GetAll() ([]*domain.Card, error)

	Update(card *domain.Card) error

	UpdateTitle(id int, title *string) error

	Delete(id int) error
}

type TaskStorage interface {
	Create(task *domain.Task) error

	GetByID(id int) (*domain.Task, error)

	GetAll() ([]*domain.Task, error)

	GetByCardID(cardID int) ([]*domain.Task, error)

	Update(task *domain.Task) error

	UpdateName(id int, name *string) error

	UpdateCompleted(id int, completed bool) error

	Delete(id int) error

	DeleteByCardID(cardID int) error
}
