package dto

type FcmTokenRequest struct {
	ID       string `json:"id"`
	Token    string `json:"token"`
	Platform string `json:"platform"`
}
