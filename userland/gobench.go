package main
import (
  "fmt"
  "testing"
  "net/http"
)

type HttpResponse struct {
  url string
  response *http.Response
  err error
}

func BenchmarkHello(b *testing.B) {
    for i := 0; i < b.N; i++ {
        fmt.Printf("hello")
    }
}
func BenchmarkGet(b *testing.B) {
    for i := 0; i < b.N; i++ {
        fmt.Printf("hello")
    }
}
