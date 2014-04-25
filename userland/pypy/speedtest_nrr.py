import benchmark
import httplib
import json
import msgpack
import userland_pb2

class Benchmark_Serialization(benchmark.Benchmark):
    each = 5
    def setUp(self):
        self.con = httplib.HTTPConnection("localhost:8080")
        self.size = 10000

    def test_json(self):
        self.con.request("GET", "/users.json", headers={"Connection":" keep-alive"})
        result = self.con.getresponse()
        msg = result.read()
        for i in xrange(self.size):
            data = json.loads(msg)
            if data[0]['login'] != "someguy":
                raise Exception('boom')

    def test_msgpack(self):
        self.con.request("GET", "/users.msgpack", headers={"Connection":" keep-alive"})
        result = self.con.getresponse()
        msg = result.read()
        for i in xrange(self.size):
            data = msgpack.unpackb(msg)
            if data[0]['login'] != "someguy":
                raise Exception('boom')

    def test_protobuf(self):
        users_message = userland_pb2.Users()
        self.con.request("GET", "/users.protobuf", headers={"Connection":" keep-alive"})
        result = self.con.getresponse()
        msg = result.read()
        for i in xrange(self.size):
            users_message.ParseFromString(msg)
            if users_message.user[0].login != "someguy":
                raise Exception('boom')

    def tearDown(self):
        self.con.close()



if __name__ == '__main__':
    benchmark.main(format="markdown", numberFormat="%.4g")
    # could have written benchmark.main(each=50) if the
    # first class shouldn't have been run 100 times.
