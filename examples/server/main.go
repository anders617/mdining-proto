package main

import (
	"context"
	"flag"
	"fmt"
	"io/ioutil"
	"net"
	"os"

	pb "github.com/anders617/mdining-proto/proto/mdining"
	"github.com/golang/protobuf/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

//
// ReadProtoFromFile - Reads a proto from the given file path
//
func ReadProtoFromFileOrDie(path string, p proto.Message) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		fmt.Printf("Failed to read in text proto, %v\n", err)
		os.Exit(1)
	}
	if proto.UnmarshalText(string(data), p) != nil {
		fmt.Printf("Failed to read in text proto, %v\n", err)
		os.Exit(1)
	}
}

type server struct {
	diningHallsReply       pb.DiningHallsReply
	itemsReply             pb.ItemsReply
	filterableEntriesReply pb.FilterableEntriesReply
	allReply               pb.AllReply
}

func newserver() *server {
	s := new(server)
	ReadProtoFromFileOrDie("proto/sample/dininghalls.proto.txt", &s.diningHallsReply)
	ReadProtoFromFileOrDie("proto/sample/items.proto.txt", &s.itemsReply)
	ReadProtoFromFileOrDie("proto/sample/filterableentries.proto.txt", &s.filterableEntriesReply)
	s.allReply = pb.AllReply{
		DiningHalls:       s.diningHallsReply.DiningHalls,
		Items:             s.itemsReply.Items,
		FilterableEntries: s.filterableEntriesReply.FilterableEntries}
	return s
}

func (s *server) GetDiningHalls(ctx context.Context, req *pb.DiningHallsRequest) (*pb.DiningHallsReply, error) {
	fmt.Printf("GetDiningHalls req{%v}\n", req)
	return &s.diningHallsReply, nil
}

func (s *server) GetItems(ctx context.Context, req *pb.ItemsRequest) (*pb.ItemsReply, error) {
	fmt.Printf("GetItems req{%v}\n", req)
	return &s.itemsReply, nil
}

func (s *server) GetFilterableEntries(ctx context.Context, req *pb.FilterableEntriesRequest) (*pb.FilterableEntriesReply, error) {
	fmt.Printf("GetFilterableEntries req{%v}\n", req)
	return &s.filterableEntriesReply, nil
}

func (s *server) GetAll(ctx context.Context, req *pb.AllRequest) (*pb.AllReply, error) {
	fmt.Printf("GetAll req{%v}\n", req)
	return &s.allReply, nil
}

func (s *server) GetMenu(ctx context.Context, req *pb.MenuRequest) (*pb.MenuReply, error) {
	fmt.Printf("GetMenu req{%v}\n", req)
	return nil, status.New(codes.Unimplemented, "Unimplemented").Err()
}

func (s *server) GetFood(ctx context.Context, req *pb.FoodRequest) (*pb.FoodReply, error) {
	fmt.Printf("GetFood req{%v}\n", req)
	return nil, status.New(codes.Unimplemented, "Unimplemented").Err()
}

func (s *server) GetFoodStats(ctx context.Context, req *pb.FoodStatsRequest) (*pb.FoodStatsReply, error) {
	fmt.Printf("GetFoodStats req{%v}\n", req)
	return nil, status.New(codes.Unimplemented, "Unimplemented").Err()
}

//
// Serves GRPC requests
//
func serveGRPC(port string, server *server) {
	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		fmt.Printf("Failed to listen: %v\n", err)
		os.Exit(1)
	}
	s := grpc.NewServer()

	// Register server
	pb.RegisterMDiningServer(s, server)

	fmt.Printf("Serving GRPC Requests on %s\n", port)
	if err := s.Serve(lis); err != nil {
		fmt.Printf("failed to server: %v", err)
		os.Exit(1)
	}
}

func main() {
	port := flag.String("port", "50051", "The port to serve on")
	flag.Parse()
	s := newserver()
	serveGRPC(*port, s)
}
