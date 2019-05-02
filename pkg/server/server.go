package main

import (
	"context"
	"fmt"
	"log"
	"net"

	"github.com/curtisr7/hello/pkg/service"
	"google.golang.org/grpc"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *service.HelloRequest) (*service.HelloReply, error) {
	fmt.Printf("Received: %v\n", in.Name)
	return &service.HelloReply{Message: "Hello " + in.Name}, nil
}

func main() {

	lis, err := net.Listen("tcp", "localhost:8080")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	service.RegisterGreeterServer(s, &server{})

	fmt.Println("listening on :8080")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
