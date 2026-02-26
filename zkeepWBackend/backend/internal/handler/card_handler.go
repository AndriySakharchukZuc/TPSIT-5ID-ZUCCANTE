package handler

import (
	"net/http"
	"strconv"

	"example.com/internal/domain"
	"example.com/internal/storage"
	"github.com/gin-gonic/gin"
)

type CardHandler struct {
	storage storage.CardStorage
}

func NewCardHandler(storage storage.CardStorage) *CardHandler {
	return &CardHandler{storage: storage}
}

type createCardInput struct {
	ID    int    `json:"id"`
	Title string `json:"title"`
}

type updateCardInput struct {
	Title string `json:"title" binding:"required"`
}

func (h *CardHandler) CreateCard(c *gin.Context) {
	var input createCardInput
	if err := c.ShouldBindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	card := &domain.Card{
		Title: &input.Title,
	}

	if err := h.storage.Create(card); err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusCreated, card)
}

func (h *CardHandler) GetAllCards(c *gin.Context) {
	cards, err := h.storage.GetAll()
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, cards)
}

func (h *CardHandler) GetCard(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid id param")
		return
	}

	card, err := h.storage.GetByID(id)
	if err != nil {
		newErrorResponse(c, http.StatusNotFound, "card not found")
		return
	}

	c.JSON(http.StatusOK, card)
}

func (h *CardHandler) UpdateCard(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid id param")
		return
	}

	var input updateCardInput
	if err := c.ShouldBindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	if _, err := h.storage.GetByID(id); err != nil {
		newErrorResponse(c, http.StatusNotFound, "card not found")
		return
	}

	if err := h.storage.UpdateTitle(id, &input.Title); err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, statusResponse{Status: "updated"})
}

func (h *CardHandler) DeleteCard(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		newErrorResponse(c, http.StatusBadRequest, "invalid id param")
		return
	}

	if err := h.storage.Delete(id); err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, statusResponse{Status: "deleted"})
}
