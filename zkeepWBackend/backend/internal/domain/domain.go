package domain

type Card struct {
	ID    int     `json:"id" gorm:"primaryKey;autoIncrement"`
	Title *string `json:"title" gorm:"default:null"`
}

type Task struct {
	ID        int     `json:"id" gorm:"primaryKey;autoIncrement"`
	CardID    int     `json:"card_id" gorm:"not null"`
	Name      *string `json:"name" gorm:"default:null"`
	Completed bool    `json:"completed" gorm:"default:false"`

	Card Card `json:"-" gorm:"foreignKey:CardID;references:ID;constraint:OnDelete:CASCADE"`
}
