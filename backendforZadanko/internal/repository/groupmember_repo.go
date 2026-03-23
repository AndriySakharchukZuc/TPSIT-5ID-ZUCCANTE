package repository

import "zadanko/internal/entity"

type GroupMemberRepository interface {
	Create(member *entity.GroupMember) error
	Delete(groupID string, userID string) error
	GetByGroupID(groupID string) ([]*entity.GroupMember, error)
}
