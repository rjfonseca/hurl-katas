POST http://api:8000/hello
Content-Type: application/json

{ "name": "Bar" }

HTTP 200
[Asserts]
body contains "hello Bar!"
