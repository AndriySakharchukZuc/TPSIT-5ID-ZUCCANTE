package services

import (
	"crypto/sha256"
	"fmt"
	"zadanko/internal/dto"
	"zadanko/internal/entity"
	"zadanko/internal/repository"
)

type GroupService struct {
	groupRepo       repository.GroupRepository
	groupMemberRepo repository.GroupMemberRepository
}

func NewGroupService(groupRepo repository.GroupRepository, groupMemberRepo repository.GroupMemberRepository) *GroupService {
	return &GroupService{groupRepo: groupRepo, groupMemberRepo: groupMemberRepo}
}

func (s *GroupService) Create(userID string, input dto.CreateGroupRequest) (*entity.Group, error) {
	group := &entity.Group{
		ID:         input.ID,
		Name:       input.Name,
		CreatedBy:  userID,
		InviteCode: generateInviteCode(input.ID),
	}

	member := &entity.GroupMember{
		ID:      fmt.Sprintf("%s-%s", input.ID, userID),
		GroupID: input.ID,
		UserID:  userID,
		Role:    "owner",
	}

	if err := s.groupRepo.CreateWithOwner(group, member); err != nil {
		return nil, err
	}

	return group, nil
}

func (s *GroupService) GetByUserID(userID string) ([]*entity.Group, error) {
	return s.groupRepo.GetByUserID(userID)
}

func (s *GroupService) Join(userID string, input dto.JoinGroupRequest) error {
	group, err := s.groupRepo.GetByInviteCode(input.InviteCode)
	if err != nil {
		return err
	}

	member := &entity.GroupMember{
		ID:      input.ID,
		GroupID: group.ID,
		UserID:  userID,
		Role:    "member",
	}

	return s.groupMemberRepo.Create(member)
}

func generateInviteCode(groupID string) string {
	hash := sha256.Sum256([]byte(groupID))
	return fmt.Sprintf("%x", hash)[:8]
}
