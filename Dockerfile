FROM golang:1.23 as base

# all the commands will be executed in the WORKDIR
WORKDIR /app

# its like requirements.txt file and pom.xml
COPY go.mod .

# download dependency from pom.xml
RUN go mod download 

#copy the source code onto the docker

COPY . . 

# this is what i ran locally. artificat or binary called main will be created in the docker image
RUN go build -o main . 

# Expose 8080
# CMD [ "./main" ]  # from here we can run image but this will be not reduced the size. 

# final stage - distroless image
FROM gcr.io/distroless/base

# copy above binary file on on to the distroless image. default location
COPY --from=base /app/main . 

# copy the static content. this is not bundle in the binary
COPY --from=base /app/static ./static

EXPOSE 8080
CMD [ "./main" ]
