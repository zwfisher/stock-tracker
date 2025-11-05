package server

import (
	"os"
	"os/signal"
	"syscall"

	"github.com/zwfisher/stock-tracker/ingestionservice/internal/config"
)

type Server struct {
	config        *config.Config
	websocket     *WebSocketServer
	kafkaProducer *KafkaProducer
}

func NewServer(config *config.Config, interruptChan chan os.Signal) (*Server, error) {
	s := &Server{
		config:        config,
		websocket:     NewWebSocketServer(),
		kafkaProducer: NewKafkaProducer(),
	}

	return s, nil
}