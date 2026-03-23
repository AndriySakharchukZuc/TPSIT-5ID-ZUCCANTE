package postgres

import (
	"zadanko/internal/entity"

	"gorm.io/gorm"
)

type groupRepository struct {
	db *gorm.DB
}

func NewGroupRepository(db *gorm.DB) *groupRepository {
	return &groupRepository{db: db}
}

func (r *groupRepository) CreateWithOwner(group *entity.Group, member *entity.GroupMember) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(group).Error; err != nil {
			return err
		}
		return tx.Create(member).Error
	})
}

func (r *groupRepository) GetByID(id string) (*entity.Group, error) {
	var group entity.Group
	err := r.db.Where("id = ?", id).Find(&group).Error
	return &group, err
}

func (r *groupRepository) GetByInviteCode(code string) (*entity.Group, error) {
	var group entity.Group
	err := r.db.Where("invite_code = ?", code).First(&group).Error
	return &group, err
}

func (r *groupRepository) GetByUserID(userID string) ([]*entity.Group, error) {
	var groups []*entity.Group
	err := r.db.
		Joins("JOIN group_members ON group_members.group_id = groups.id").
		Where("group_members.user_id = ?", userID).
		Find(&groups).Error
	return groups, err
}
