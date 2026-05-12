package models

import "time"

type Group struct {
	ID         string    `json:"id" gorm:"primaryKey"`
	Name       string    `json:"name" gorm:"not null"`
	CreatedBy  string    `json:"created_by" gorm:"not null"`
	InviteCode string    `json:"invite_code" gorm:"uniqueIndex;not null"`
	CreatedAt  time.Time `json:"created_at"`
}

type GroupMember struct {
	ID       string    `json:"id" gorm:"primaryKey"`
	GroupID  string    `json:"group_id" gorm:"not null"`
	UserID   string    `json:"user_id" gorm:"not null"`
	Role     string    `json:"role" gorm:"default:member"`
	JoinedAt time.Time `json:"joined_at"`

	Group Group `json:"-" gorm:"foreignKey:GroupID;references:ID;constraint:OnDelete:CASCADE"`
}
