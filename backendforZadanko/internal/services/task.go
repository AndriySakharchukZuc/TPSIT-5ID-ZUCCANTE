package services

import (
	"zadanko/internal/dto"
	"zadanko/internal/entity"
	"zadanko/internal/repository"
)

type TaskService struct {
	taskRepo        repository.TaskRepository
	groupMemberRepo repository.GroupMemberRepository
	fcmService      *FcmService
}

func NewTaskService(taskRepo repository.TaskRepository, groupMemberRepo repository.GroupMemberRepository, fcmService *FcmService) *TaskService {
	return &TaskService{taskRepo: taskRepo, groupMemberRepo: groupMemberRepo, fcmService: fcmService}
}

func (s *TaskService) Create(userID string, groupID string, input dto.CreateTaskRequest) (*entity.Task, error) {
	task := &entity.Task{
		ID:          input.ID,
		GroupID:     groupID,
		CreatedBy:   userID,
		AssignedTo:  input.AssignedTo,
		Title:       input.Title,
		Description: input.Description,
		Status:      "todo",
		DueAt:       input.DueAt,
	}

	if err := s.taskRepo.Create(task); err != nil {
		return nil, err
	}

	go s.fcmService.NotifyGroupMembers(userID, groupID, task)

	return task, nil
}

func (s *TaskService) GetByGroupID(groupID string) ([]*entity.Task, error) {
	return s.taskRepo.GetByGroupID(groupID)
}

func (s *TaskService) Update(taskID string, input dto.UpdateTaskRequest) (*entity.Task, error) {
	task, err := s.taskRepo.GetByID(taskID)
	if err != nil {
		return nil, err
	}

	if err := s.taskRepo.Update(task); err != nil {
		return nil, err
	}

	return task, nil
}

func (s *TaskService) Delete(taskID string) error {
	return s.taskRepo.Delete(taskID)
}
