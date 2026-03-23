package services

import (
	"context"
	"log"
	"sync"
	"zadanko/internal/dto"
	"zadanko/internal/entity"
	"zadanko/internal/repository"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"
)

type FcmService struct {
	fcmRepo    repository.FcmRepository
	memberRepo repository.GroupMemberRepository
	fcmClient  *messaging.Client
}

func NewFcmService(fcmRepo repository.FcmRepository, memberRepo repository.GroupMemberRepository, credsPath string) *FcmService {
	app, err := firebase.NewApp(context.Background(), nil, option.WithCredentialsFile(credsPath))
	if err != nil {
		log.Fatalf("failed to init firebase: %v", err)
	}

	client, err := app.Messaging(context.Background())
	if err != nil {
		log.Fatalf("failed to init fcm client: %v", err)
	}

	return &FcmService{fcmRepo: fcmRepo, memberRepo: memberRepo, fcmClient: client}
}

func (s *FcmService) RegisterToken(userID string, input dto.FcmTokenRequest) error {
	token := &entity.FcmToken{
		ID:       input.ID,
		UserID:   userID,
		Token:    input.Token,
		Platform: input.Platform,
	}
	return s.fcmRepo.Create(token)
}

func (s *FcmService) NotifyGroupMembers(senderID string, groupID string, task *entity.Task) {
	if s.memberRepo == nil || s.fcmRepo == nil {
		log.Printf("fcm: skip notification, repos not initialized")
		return
	}
	members, err := s.memberRepo.GetByGroupID(groupID)
	if err != nil {
		log.Printf("fcm: failed to get group members: %v", err)
		return
	}

	var wg sync.WaitGroup
	for _, member := range members {
		if member.UserID == senderID {
			continue
		}

		tokens, err := s.fcmRepo.GetByUserID(member.UserID)
		if err != nil {
			log.Printf("fcm: failed to get tokens for user %s: %v", member.UserID, err)
			continue
		}

		for _, token := range tokens {
			wg.Add(1)
			go func(t string) {
				defer wg.Done()
				s.sendNotification(t, task)
			}(token.Token)
		}
	}
	wg.Wait()
}

func (s *FcmService) sendNotification(token string, task *entity.Task) {
	if s.fcmClient == nil {
		log.Printf("fcm: client not initialized, skipping notification to %s", token)
		return
	}
	msg := &messaging.Message{
		Token: token,
		Notification: &messaging.Notification{
			Title: "Новая задача",
			Body:  task.Title,
		},
		Data: map[string]string{
			"groupId": task.GroupID,
			"taskId":  task.ID,
		},
	}

	_, err := s.fcmClient.Send(context.Background(), msg)
	if err != nil {
		log.Printf("fcm: failed to send notification to %s: %v", token, err)
	}
}
