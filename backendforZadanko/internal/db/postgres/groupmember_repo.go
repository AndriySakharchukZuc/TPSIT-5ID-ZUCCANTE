package postgres

import (
	"zadanko/internal/entity"

	"gorm.io/gorm"
)

type groupMemberRepository struct {
	db *gorm.DB
}

func NewGroupMemberRepository(db *gorm.DB) *groupMemberRepository {
	return &groupMemberRepository{db: db}
}

func (r *groupMemberRepository) Create(member *entity.GroupMember) error {
	return r.db.Create(member).Error
}

func (r *groupMemberRepository) Delete(groupID string, userID string) error {
	return r.db.Where("group_id = ? AND user_id = ?", groupID, userID).Delete(&entity.GroupMember{}).Error
}

func (r *groupMemberRepository) GetByGroupID(groupID string) ([]*entity.GroupMember, error) {
	var groupMembers []*entity.GroupMember
	err := r.db.Where("group_id = ?", groupID).Find(&groupMembers).Error
	return groupMembers, err
}
