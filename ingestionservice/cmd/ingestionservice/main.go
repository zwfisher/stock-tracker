package main

import (
	"log"
	"os"

	"github.com/zwfisher/stock-tracker/ingestionservice/cmd/ingestionservice/commands"
)

func main() {
	if err := commands.Run(os.Args[1:]); err != nil {
		log.Println(err)
		os.Exit(1)
	}
}