# Fampay- Assignment

Flutter is used for client-side development, while Golang is used for server-side development.

### **For Client-Side**

This application utilizes the YouTube API to retrieve videos according to a search query, subsequently saving them within a local SQLite database. Furthermore, it presents a fundamental API that enables access to these stored videos. The user interface aspect of the application is developed using Flutter, which facilitates the creation of dynamic and engaging user experiences across multiple platforms.

## **Table of Contents**

- **Screenshots**
- **Installation**
- **API Configuration**

## **Screenshots**
<img width="1434" alt="Screenshot 2023-08-18 at 6 39 33 AM" src="https://github.com/SUNIL-RAGHU/Fampay/assets/89726488/06e1f126-a00e-43ab-8420-8024b4a55fc1">
<img width="1440" alt="Screenshot 2023-08-18 at 6 39 48 AM" src="https://github.com/SUNIL-RAGHU/Fampay/assets/89726488/09b4bcc8-f872-4e21-9230-114c6a1369ee">


Include relevant screenshots or GIFs showcasing your app's UI or functionality.

## **Installation**

Provide step-by-step instructions on how to get your project up and running locally.

1. **Clone the repository:**
    
    ```bash
    git clone https://github.com/SUNIL-RAGHU/Fampay.git
    ```
    
2. **Navigate to the project directory:**
    
    ```bash
    cd Fampay
    ```
    
3. **Install dependencies:**
    
    ```arduino
    flutter pub get
    ```
    
4. **Run the app:**
    
    ```arduino
    flutter run -d chrome --web-browser-flag "--disable-web-security"
    ```
    

## **API Configuration**

If your project communicates with an API, you might need to configure the API URL. Open the **`api_constants.dart`** file in your project and update the **`baseUrl`**:

```dart

class ApiConstants {
  static const baseUrl = 'http://your-new-base-url-here';
}
```

Replace **`'http://your-new-base-url-here'`** with the actual base URL of your API.

### **For Server-Side**

This is a Go application that fetches YouTube videos based on a search query and stores them in a local SQLite database. It also offers a basic API to access these videos.

**Features:**

1. **YouTube Video Fetching:** The application allows users to specify a search query, and it fetches relevant YouTube videos using the YouTube API.
2. **SQLite Database Storage:** The fetched videos are stored in a local SQLite database. This ensures that the videos are available for retrieval even after the application is restarted.
3. **Gin Framework for API:** The application employs the Gin framework, a fast and lightweight web framework for Go, to create the API endpoints. This framework simplifies the process of handling HTTP requests and building RESTful APIs.
4. **Pagination:** Pagination is implemented to manage large amounts of video data. The GET API endpoint returns videos in paginated responses, ensuring that the data is manageable and easy to navigate.
5. **Descending Order Sorting:** The fetched videos are sorted in descending order based on their published datetime. This arrangement ensures that the most recent videos appear first.

**Prerequisites:**

- Go programming language (**[https://golang.org/dl/](https://golang.org/dl/)**)
- SQLite (for local database storage)
- YouTube Data API key (**[https://developers.google.com/youtube/registering_an_application](https://developers.google.com/youtube/registering_an_application)**)

**Getting Started:**

1. Open the Server Folder :
    
    ```bash
    cd Server
    ```
    
2. Install dependencies:
    
    ```bash
    go mod tidy
    ```
    
3. Set your YouTube Data API key in **`main.go`**:
    
    ```go
    apiKey := "YOUR_API_KEY_HERE"
    ```
    

**Usage:**

1. Run the application:
    
    ```bash
    go run main.go
    ```
    
2. Access the API at [http://localhost:8000/videos?page=2](http://localhost:8000/videos?page=2)

### PostMan **Screenshots**
<img width="1440" alt="Screenshot 2023-08-18 at 7 33 54 AM" src="https://github.com/SUNIL-RAGHU/Fampay/assets/89726488/8f8707b8-8f08-44c6-8aba-77be531842b9">
<img width="1440" alt="Screenshot 2023-08-18 at 7 33 42 AM" src="https://github.com/SUNIL-RAGHU/Fampay/assets/89726488/d71b35a0-bc25-494b-aed1-63c07121ac41">

