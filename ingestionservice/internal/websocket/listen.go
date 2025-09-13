package websocket

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/websocket"
	"github.com/zwfisher/stock-tracker/ingestionservice/internal/config"
)

func Start(config *config.Config) {
	log.Println("Starting websocket service")

	finnhubToken := os.Getenv("FINNHUB_TOKEN")
	var baseUrl = "wss://ws.finnhub.io?token=" + finnhubToken

	c, _, err := websocket.DefaultDialer.Dial(baseUrl, http.Header{})
	if err != nil {
		log.Fatal("dial:", err)
	}
	defer c.Close()

	for _, s := range config.Symbols {
		msg, _ := json.Marshal(map[string]interface{}{"type": "subscribe", "symbol": s})
		c.WriteMessage(websocket.TextMessage, msg)
	}

	var msg any
	for {
		err := c.ReadJSON(&msg)
		if err != nil {
			panic(err)
		}
		fmt.Println("Message from server ", msg)
	}
}

func Stop() {
	log.Println("Stopping websocket service")
}