package repo

import "github.com/AndriySakharchukZuc/microservice-api/group-service/internal/models"

type GroupMemberRepository interface {
	Create(member *models.GroupMember) error
	Delete(groupID string, userID string) error
	GetByGroupID(groupID string) ([]*models.GroupMember, error)
}
