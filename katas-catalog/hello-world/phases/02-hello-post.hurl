POST http://api:8000/hello
Content-Type: application/json

{ "name": "Foo" }

HTTP 200
[Asserts]
body contains "hello Foo!"
