package main

import (
	"os"

	"github.com/zwfisher/stock-tracker/ingestionservice/cmd/ingestionservice/commands"
)

func main() {
	if err := commands.Run(os.Args[1:]); err != nil {
		os.Exit(1)
	}
}