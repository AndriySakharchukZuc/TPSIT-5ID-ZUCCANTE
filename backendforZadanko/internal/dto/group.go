package dto

type CreateGroupRequest struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type JoinGroupRequest struct {
	ID         string `json:"id"`
	InviteCode string `json:"invite_code"`
}
