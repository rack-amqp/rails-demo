import benchmark
import httplib
import json
import msgpack
import userland_pb2

class Benchmark_Serialization(benchmark.Benchmark):
    each = 50
    def setUp(self):
        self.con = httplib.HTTPConnection("localhost:8080")
        self.size = 10

    def test_json(self):
        for i in xrange(self.size):
            self.con.request("GET", "/users.json", headers={"Connection":" keep-alive"})
            result = self.con.getresponse()
            msg = result.read()
            data = json.loads(msg)
            if data[0]['login'] != "someguy":
                raise Exception('boom')

    def test_msgpack(self):
        for i in xrange(self.size):
            self.con.request("GET", "/users.msgpack", headers={"Connection":" keep-alive"})
            result = self.con.getresponse()
            msg = result.read()
            data = msgpack.unpackb(msg)
            if data[0]['login'] != "someguy":
                raise Exception('boom')

    def test_protobuf(self):
        users_message = userland_pb2.Users()
        for i in xrange(self.size):
            self.con.request("GET", "/users.protobuf", headers={"Connection":" keep-alive"})
            result = self.con.getresponse()
            msg = result.read()
            users_message.ParseFromString(msg)
            if users_message.user[0].login != "someguy":
                raise Exception('boom')

    def tearDown(self):
        self.con.close()



if __name__ == '__main__':
    benchmark.main(format="markdown", numberFormat="%.4g")
    # could have written benchmark.main(each=50) if the
    # first class shouldn't have been run 100 times.
