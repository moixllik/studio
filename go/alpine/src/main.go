package main

import (
	"net/http"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/hello", getHello)
	router.Run("0.0.0.0:8080")
}

func getHello(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, gin.H{"say": "Hello, World!"})
}
