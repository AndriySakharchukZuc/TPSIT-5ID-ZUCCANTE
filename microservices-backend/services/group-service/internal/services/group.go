package services

import (
	"crypto/sha256"
	"fmt"
	"time"

	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/dto"
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/models"
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/repo"
)

type GroupService struct {
	groupRepo       repo.GroupRepository
	groupMemberRepo repo.GroupMemberRepository
}

func NewGroupService(groupRepo repo.GroupRepository, groupMemberRepo repo.GroupMemberRepository) *GroupService {
	return &GroupService{groupRepo: groupRepo, groupMemberRepo: groupMemberRepo}
}

func (s *GroupService) Create(userID string, input dto.CreateGroupRequest) (*models.Group, error) {
	group := &models.Group{
		ID:         input.ID,
		Name:       input.Name,
		CreatedBy:  userID,
		InviteCode: generateInviteCode(input.ID),
	}

	member := &models.GroupMember{
		ID:       fmt.Sprintf("%s-%s", input.ID, userID),
		GroupID:  input.ID,
		UserID:   userID,
		Role:     "owner",
		JoinedAt: time.Now(),
	}

	if err := s.groupRepo.CreateWithOwner(group, member); err != nil {
		return nil, err
	}

	return group, nil
}

func (s *GroupService) GetByUserID(userID string) ([]*models.Group, error) {
	return s.groupRepo.GetByUserID(userID)
}

func (s *GroupService) Join(userID string, input dto.JoinGroupRequest) error {
	group, err := s.groupRepo.GetByInviteCode(input.InviteCode)
	if err != nil {
		return err
	}

	member := &models.GroupMember{
		ID:       input.ID,
		GroupID:  group.ID,
		UserID:   userID,
		Role:     "member",
		JoinedAt: time.Now(),
	}

	return s.groupMemberRepo.Create(member)
}

func generateInviteCode(groupID string) string {
	hash := sha256.Sum256([]byte(groupID))
	return fmt.Sprintf("%x", hash)[:8]
}
