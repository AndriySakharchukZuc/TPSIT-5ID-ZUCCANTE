package entity

import "time"

type User struct {
	ID           string    `json:"id" gorm:"primaryKey"`
	Username     string    `json:"username" gorm:"not null"`
	Email        string    `json:"email" gorm:"not null"`
	PasswordHash string    `json:"-" gorm:"not null"`
	AvatarURL    string    `json:"avatar_url"`
	CreatedAt    time.Time `json:"created_at"`
}

type FcmToken struct {
	ID        string    `json:"id" gorm:"primaryKey"`
	UserID    string    `json:"user_id" gorm:"not null"`
	Token     string    `json:"token" gorm:"not null"`
	Platform  string    `json:"platform"`
	CreatedAt time.Time `json:"created_at"`

	User User `json:"-" gorm:"foreignKey:UserID;references:ID;constraint:OnDelete:CASCADE"` //UserID -> User.ID
}

type Group struct {
	ID         string    `json:"id" gorm:"primaryKey"`
	Name       string    `json:"name" gorm:"not null"`
	CreatedBy  string    `json:"created_by" gorm:"not null"`
	InviteCode string    `json:"invite_code" gorm:"uniqueIndex;not null"`
	CreatedAt  time.Time `json:"created_at"`

	User User `json:"-" gorm:"foreignKey:CreatedBy;references:ID;constraint:OnDelete:CASCADE"` //CreatedBy -> User.ID
}

type GroupMember struct {
	ID       string    `json:"id" gorm:"primaryKey"`
	GroupID  string    `json:"group_id" gorm:"not null"`
	UserID   string    `json:"user_id" gorm:"not null"`
	Role     string    `json:"role" gorm:"default:member"`
	JoinedAt time.Time `json:"joined_at"`

	Group Group `json:"-" gorm:"foreignKey:GroupID;references:ID;constraint:OnDelete:CASCADE"` //GroupID -> Group.ID
	User  User  `json:"user" gorm:"foreignKey:UserID;references:ID;constraint:OnDelete:CASCADE"`  //UserID -> User.ID
}

type Task struct {
	ID          string     `json:"id" gorm:"primaryKey"`
	GroupID     string     `json:"group_id" gorm:"not null"`
	CreatedBy   string     `json:"created_by" gorm:"not null"`
	AssignedTo  *string    `json:"assigned_to"` // pointer because can be null
	Title       string     `json:"title" gorm:"not null"`
	Description string     `json:"description"`
	Status      string     `json:"status" gorm:"default:todo"`
	IsDeleted   bool       `json:"is_deleted" gorm:"default:false"`
	DueAt       *time.Time `json:"due_at"` // pointer because can be null
	CreatedAt   time.Time  `json:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at"`

	Group    Group `json:"-" gorm:"foreignKey:GroupID;references:ID;constraint:OnDelete:CASCADE"`    //GroupID -> Group.ID
	Owner    User  `json:"-" gorm:"foreignKey:CreatedBy;references:ID;constraint:OnDelete:CASCADE"`  //CreatedBy -> User.ID
	Assignee *User `json:"-" gorm:"foreignKey:AssignedTo;references:ID;constraint:OnDelete:CASCADE"` //AssignedTo -> User.ID
}
