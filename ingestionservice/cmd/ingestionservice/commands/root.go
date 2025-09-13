package commands

import (
	"errors"
	"flag"

	"github.com/zwfisher/stock-tracker/ingestionservice/internal/websocket"
	"github.com/zwfisher/stock-tracker/ingestionservice/internal/config"
)

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
		config := config.LoadConfig(*startConfig)

		websocket.Start(config)
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
