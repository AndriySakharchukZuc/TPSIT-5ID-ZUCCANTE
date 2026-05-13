package services

import (
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/models"
	"github.com/AndriySakharchukZuc/microservice-api/group-service/internal/repo"
)

type GroupMemberService struct {
	groupMemberRepo repo.GroupMemberRepository
}

func NewGroupMemberService(groupMemberRepo repo.GroupMemberRepository) *GroupMemberService {
	return &GroupMemberService{groupMemberRepo: groupMemberRepo}
}

func (s *GroupMemberService) Add(groupID string, userID string) error {
	return s.groupMemberRepo.Create(&models.GroupMember{
		GroupID: groupID,
		UserID:  userID,
		Role:    "member",
	})
}

func (s *GroupMemberService) Remove(groupID string, userID string) error {
	return s.groupMemberRepo.Delete(groupID, userID)
}

func (s *GroupMemberService) GetByGroupID(groupID string) ([]*models.GroupMember, error) {
	return s.groupMemberRepo.GetByGroupID(groupID)
}
