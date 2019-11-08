package main

import (
	"context"
	"flag"
	"fmt"
	"os"

	pb "github.com/anders617/mdining-proto/proto/mdining"
	"google.golang.org/grpc"
)

func main() {
	address := flag.String("address", "localhost:50051", "The address of the mdining server to connect to.")
	flag.Parse()
	fmt.Printf("Connecting...")
	conn, err := grpc.Dial(*address, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		fmt.Printf("Could not dial %s: %s", address, err)
		os.Exit(1)
	}
	fmt.Printf("Connected")
	defer conn.Close()
	c := pb.NewMDiningClient(conn)
	diningHallsReply, err := c.GetDiningHalls(context.Background(), &pb.DiningHallsRequest{})
	if err != nil {
		fmt.Printf("Could not call GetDiningHalls: %s", err)
		os.Exit(1)
	}
	fmt.Printf("DiningHallsReply: %v", diningHallsReply)
}
