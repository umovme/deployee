FROM golang:1.10 AS build
    ENV APP_HOME /go/src/github.com/umovme/deployee
    WORKDIR $APP_HOME
    COPY . ${APP_HOME}

    RUN go get -v github.com/gorilla/mux
    RUN go get -v github.com/aws/aws-sdk-go
    RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o deployee .

FROM scratch
    ENV APP_HOME /app
    WORKDIR $APP_HOME

    COPY static ${APP_HOME}/static
    COPY --from=build /go/src/github.com/umovme/deployee/deployee .

    EXPOSE 3001
    CMD ["/app/deployee"]
