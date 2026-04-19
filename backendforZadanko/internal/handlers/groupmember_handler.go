package handlers

import (
	"net/http"
	"zadanko/internal/services"

	"github.com/gin-gonic/gin"
)

type GroupMemberHandler struct {
	groupMemberService *services.GroupMemberService
}

func NewGroupMemberHandler(groupMemberService *services.GroupMemberService) *GroupMemberHandler {
	return &GroupMemberHandler{groupMemberService: groupMemberService}
}

func (h *GroupMemberHandler) Add(c *gin.Context) {
	groupID := c.Param("id")
	userID := c.GetString("user_id")

	if err := h.groupMemberService.Add(groupID, userID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "member added"})
}

func (h *GroupMemberHandler) Remove(c *gin.Context) {
	groupID := c.Param("id")
	userID := c.Param("userId")

	if err := h.groupMemberService.Remove(groupID, userID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "member removed"})
}

func (h *GroupMemberHandler) GetByGroup(c *gin.Context) {
	groupID := c.Param("id")

	members, err := h.groupMemberService.GetByGroupID(groupID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, members)
}
