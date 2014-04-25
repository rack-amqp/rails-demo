package main
//import (
//  "testing"
//  "net/http"
//  "io/ioutil"
//  "github.com/vmihailenco/msgpack"
//  "encoding/json"
//  "code.google.com/p/goprotobuf/proto"
//  "userland"
//)

//func BenchmarkJSONOb(b *testing.B) {
//  tr := &http.Transport{}
//  client := &http.Client{Transport: tr}
//  for i := 0; i < b.N; i++ {
//    var users []userland.User
//    resp, _ := client.Get("http://localhost:8080/users.json")
//    data, _ := ioutil.ReadAll(resp.Body)
//    json.Unmarshal(data, &users);

//    if(*users[0].Login != "someguy"){ panic("boom") }
//  }
//}
//func BenchmarkJSON(b *testing.B) {
//  tr := &http.Transport{}
//  client := &http.Client{Transport: tr}
//  for i := 0; i < b.N; i++ {
//    var users []map[string]interface{}
//    resp, _ := client.Get("http://localhost:8080/users.json")
//    data, _ := ioutil.ReadAll(resp.Body)
//    json.Unmarshal(data, &users);

//    if(users[0]["login"] != "someguy"){ panic("boom") }
//  }
//}
//func BenchmarkPB(b *testing.B) {
//  tr := &http.Transport{}
//  client := &http.Client{Transport: tr}
//  for i := 0; i < b.N; i++ {
//    users := &userland.Users{}
//    resp, _ := client.Get("http://localhost:8080/users.protobuf")
//    data, _ := ioutil.ReadAll(resp.Body)
//    proto.Unmarshal(data, users);

//    if(*users.User[0].Login != "someguy"){ panic("boom") }
//  }
//}
//func BenchmarkMPk(b *testing.B) {
//  tr := &http.Transport{}
//  client := &http.Client{Transport: tr}
//  for i := 0; i < b.N; i++ {
//    var users []map[string]interface{}
//    resp, _ := client.Get("http://localhost:8080/users.msgpack")
//    data, _ := ioutil.ReadAll(resp.Body)
//    msgpack.Unmarshal(data, &users);

//    if(users[0]["login"] != "someguy"){ panic("boom") }
//  }
//}
