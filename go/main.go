package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello World! Chandra 10 PM Sat night Samal")
	})
	r.Run() // listen on 0.0.0.0:8080
}
