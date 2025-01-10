#  Usage

`sam build`

once built, update the template CodeUri from
```
    CodeUri: .
    
    to
    
    CodeUri: .aws-sam/build/PetStore
```
Still figuring out how to skip this step

then you can run 

`DOCKER_HOST=unix://$HOME/.docker/run/docker.sock sam local start-api --template template.yml`

Can test against it with schemathesis

schemathesis run --checks all ./Sources/PetStore/openapi.yaml --base-url http://127.0.0.1:3000
