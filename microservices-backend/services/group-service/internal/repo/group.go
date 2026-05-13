package repo

import "github.com/AndriySakharchukZuc/microservice-api/group-service/internal/models"

type GroupRepository interface {
	CreateWithOwner(group *models.Group, member *models.GroupMember) error
	GetByID(id string) (*models.Group, error)
	GetByOwner(ownerid string) ([]*models.Group, error)
	GetByInviteCode(code string) (*models.Group, error)
	GetByUserID(userID string) ([]*models.Group, error)
}
