package postgres

import (
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/models"
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/repo"
	"gorm.io/gorm"
)

type groupMemberRepository struct {
	db *gorm.DB
}

func NewGroupMemberRepository(db *gorm.DB) repo.GroupMemberRepository {
	return &groupMemberRepository{db: db}
}

func (r *groupMemberRepository) Create(member *models.GroupMember) error {
	return r.db.Create(member).Error
}

func (r *groupMemberRepository) Delete(groupID string, userID string) error {
	return r.db.Where("group_id = ? AND user_id = ?", groupID, userID).Delete(&models.GroupMember{}).Error
}

func (r *groupMemberRepository) GetByGroupID(groupID string) ([]*models.GroupMember, error) {
	var groupMembers []*models.GroupMember
	err := r.db.Where("group_id = ?", groupID).Find(&groupMembers).Error
	return groupMembers, err
}
