package services

import (
	"zadanko/internal/entity"
	"zadanko/internal/repository"
)

type GroupMemberService struct {
	groupMemberRepo repository.GroupMemberRepository
}

func NewGroupMemberService(groupMemberRepo repository.GroupMemberRepository) *GroupMemberService {
	return &GroupMemberService{groupMemberRepo: groupMemberRepo}
}

func (s *GroupMemberService) Add(groupID string, userID string) error {
	return s.groupMemberRepo.Create(&entity.GroupMember{
		GroupID: groupID,
		UserID:  userID,
		Role:    "member",
	})
}

func (s *GroupMemberService) Remove(groupID string, userID string) error {
	return s.groupMemberRepo.Delete(groupID, userID)
}
