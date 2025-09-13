package config

import (
	"log"
	"os"

	"github.com/goccy/go-yaml"
)

type Secrets struct {
	FinnhubToken string `yaml:"finnhub_token"`
}

type Config struct {
	Symbols []string `yaml:"symbols"`
	Secrets Secrets `yaml:"secrets"`
}

func LoadConfig(path string) *Config {
	// open the yaml file at the path and parse into Config struct
	configFile, err := os.ReadFile(path)

	if err != nil {
		log.Fatalf("error reading config file: %v", err)
	}

	var config Config
	if err := yaml.Unmarshal(configFile, &config); err != nil {
		log.Fatalf("error parsing config file: %v", err)
	}

	return &config
}