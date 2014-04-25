package main
import (
  "testing"
  "net/http"
  "io/ioutil"
  "github.com/vmihailenco/msgpack"
  "encoding/json"
  "code.google.com/p/goprotobuf/proto"
  "userland"
)

func BenchmarkJSONOb(b *testing.B) {
  tr := &http.Transport{}
  client := &http.Client{Transport: tr}
    var users []userland.User
    resp, _ := client.Get("http://localhost:8080/users.json")
    data, _ := ioutil.ReadAll(resp.Body)
  for i := 0; i < b.N; i++ {
    json.Unmarshal(data, &users);

    if(*users[0].Login != "someguy"){ panic("boom") }
  }
}
func BenchmarkJSON(b *testing.B) {
  tr := &http.Transport{}
  client := &http.Client{Transport: tr}
    var users []map[string]interface{}
    resp, _ := client.Get("http://localhost:8080/users.json")
    data, _ := ioutil.ReadAll(resp.Body)
  for i := 0; i < b.N; i++ {
    json.Unmarshal(data, &users);

    if(users[0]["login"] != "someguy"){ panic("boom") }
  }
}
func BenchmarkPB(b *testing.B) {
  tr := &http.Transport{}
  client := &http.Client{Transport: tr}
    users := &userland.Users{}
    resp, _ := client.Get("http://localhost:8080/users.protobuf")
    data, _ := ioutil.ReadAll(resp.Body)
  for i := 0; i < b.N; i++ {
    proto.Unmarshal(data, users);

    if(*users.User[0].Login != "someguy"){ panic("boom") }
  }
}
func BenchmarkMPk(b *testing.B) {
  tr := &http.Transport{}
  client := &http.Client{Transport: tr}
    var users []map[string]interface{}
    resp, _ := client.Get("http://localhost:8080/users.msgpack")
    data, _ := ioutil.ReadAll(resp.Body)
  for i := 0; i < b.N; i++ {
    msgpack.Unmarshal(data, &users);

    if(users[0]["login"] != "someguy"){ panic("boom") }
  }
}
