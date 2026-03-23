package repository

import "zadanko/internal/entity"

type GroupRepository interface {
	CreateWithOwner(group *entity.Group, member *entity.GroupMember) error
	GetByID(id string) (*entity.Group, error)
	GetByInviteCode(code string) (*entity.Group, error)
	// GetGroupsByUserID(userID string) ([]*entity.Group, error)
	GetByUserID(userID string) ([]*entity.Group, error)
}
