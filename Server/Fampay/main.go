package main

import (
	"log"
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
	"google.golang.org/api/option"
	"google.golang.org/api/youtube/v3"
)

type Video struct {
	gorm.Model
	Title         string    `gorm:"not null"`
	Description   string
	PublishedAt   time.Time `gorm:"index;not null"`
	ThumbnailsURL string
}

func main() {
	router := gin.Default()
	db, err := gorm.Open("sqlite3", "videos.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	db.AutoMigrate(&Video{})

	apiKey := "AIzaSyAFhqbTappRTD1pJ36xDkJEFJuYuQJ8GGA"

	client := &http.Client{}
	service, err := youtube.NewService(client, option.WithAPIKey(apiKey))
	if err != nil {
		log.Fatalf("Error creating YouTube service: %v", err)
	}

	searchQuery := "Anime"

	var wg sync.WaitGroup
	videoChannel := make(chan Video)

	go fetchVideos(service, searchQuery, videoChannel, &wg, db)

	// Start the Gin server
	go func() {
		router.GET("/videos", func(c *gin.Context) {
			var videos []Video
			db.Order("published_at DESC").Find(&videos)
            
			page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
			perPage := 10
			startIdx := (page - 1) * perPage
			endIdx := startIdx + perPage
			if endIdx > len(videos) {
				endIdx = len(videos)
			}
			paginatedVideos := videos[startIdx:endIdx]

			c.JSON(http.StatusOK, paginatedVideos)
		})

		router.Run(":8000")
	}()

	
	for {
		time.Sleep(10 * time.Second)
		go fetchVideos(service, searchQuery, videoChannel, &wg, db)
	}

}

func fetchVideos(service *youtube.Service, searchQuery string, videoChannel chan<- Video, wg *sync.WaitGroup, db *gorm.DB) {
	defer wg.Done()
	wg.Add(1)

	call := service.Search.List([]string{"snippet"}).Q(searchQuery).Type("video").Order("date").MaxResults(10)

	response, err := call.Do()
	if err != nil {
		log.Printf("Error making YouTube API call: %v", err)
		return
	}

	for _, item := range response.Items {
		publishDatetime, _ := time.Parse(time.RFC3339, item.Snippet.PublishedAt)
		video := Video{
			Title:         item.Snippet.Title,
			Description:   item.Snippet.Description,
			PublishedAt:   publishDatetime,
			ThumbnailsURL: item.Snippet.Thumbnails.Default.Url,
		
		}
		db.Create(&video)

		videoChannel <- video
	}
}
