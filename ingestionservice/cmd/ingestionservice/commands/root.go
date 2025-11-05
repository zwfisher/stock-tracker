package commands

import (
	"errors"
	"flag"
	"log"
	"os"

	"go.uber.org/zap"

	"github.com/zwfisher/stock-tracker/ingestionservice/internal/config"
	"github.com/zwfisher/stock-tracker/ingestionservice/internal/websocket"
)

func init() {
	logger := zap.Must(zap.NewProduction())
    if os.Getenv("APP_ENV") == "development" {
        logger = zap.Must(zap.NewDevelopment())
    }

    zap.ReplaceGlobals(logger)
}

func Run(args []string) error {
	if (len(args) < 1) {
		return errors.New("unknown command")
	}

	startCmd := flag.NewFlagSet("start", flag.ExitOnError)
	startConfig := startCmd.String("c", "./config.yaml", "Path to config file")

	stopCmd := flag.NewFlagSet("stop", flag.ExitOnError)

	flag.Parse()
	switch args[0] {
	case "start":
		startCmd.Parse(args[1:])
		err := makeServerAndRun()
		if err != nil {
			log.Fatalf("error running server: %v", err)
		}
		break
	case "stop":
		stopCmd.Parse(args[1:])
		websocket.Stop()
		break
	default:
		panic("unknown command: " + args[0])
	}
	return nil
}

func makeServerAndRun() error {
	interruptChan := make(chan os.Signal, 1)
	config := config.LoadConfig(*startConfig)

	server, err := server.NewServer(config, interruptChan)
	if err != nil {
		zap.L().Error("error creating server", zap.Error(err))
		return err
	}

	return nil
}
