package main

import("time")

type Video struct{
	ID            uint      `gorm:"primary_key"`
	Title         string    `gorm:"not null"`
	Description   string
	PublishedAt   time.Time `gorm:"index;not null"`
	ThumbnailsURL string
}

// apiKey := "AIzaSyAFhqbTappRTD1pJ36xDkJEFJuYuQJ8GGA"