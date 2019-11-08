#include <iostream>
#include <memory>
#include <string>

#include <grpcpp/grpcpp.h>

#include "proto/mdining.grpc.pb.h"

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;
using mdining::AllReply;
using mdining::AllRequest;
using mdining::DiningHallsReply;
using mdining::DiningHallsRequest;
using mdining::FilterableEntriesReply;
using mdining::FilterableEntriesRequest;
using mdining::ItemsReply;
using mdining::ItemsRequest;
using mdining::MenuRequest;
using mdining::MenuReply;
using mdining::FoodRequest;
using mdining::FoodReply;
using mdining::MDining;



int main(int argc, char **argv) {
  // Instantiate the client. It requires a channel, out of which the actual RPCs
  // are created. This channel models a connection to an endpoint (in this case,
  // localhost at port 50051). We indicate that the channel isn't authenticated
  // (use of InsecureChannelCredentials()).
  std::shared_ptr<Channel> channel = grpc::CreateChannel(
      "localhost:50051", grpc::InsecureChannelCredentials());
  std::unique_ptr<MDining::Stub> stub = MDining::NewStub(channel);

  // Send a GetDiningHalls request
  DiningHallsRequest diningHallsReq;
  DiningHallsReply diningHallsReply;
  ClientContext diningHallsContext;
  Status status = stub->GetDiningHalls(&diningHallsContext, diningHallsReq, &diningHallsReply);

  if (!status.ok()) {
    std::cerr << "Error getting dininghalls: " << status.error_message() << std::endl;
  } else {
    std::cout << "DiningHalls" << diningHallsReply.DebugString() << std::endl;
  }

  // Send a GetItems request
  ItemsRequest itemsReq;
  ItemsReply itemsReply;
  ClientContext itemsContext;
  status = stub->GetItems(&itemsContext, itemsReq, &itemsReply);

  if (!status.ok()) {
    std::cerr << "Error getting items: " << status.error_message() << std::endl;
  } else {
    std::cout << "Items" << itemsReply.DebugString() << std::endl;
  }

  // Send a GetFilterableEntries request
  FilterableEntriesRequest filterableEntriesReq;
  FilterableEntriesReply filterableEntriesReply;
  ClientContext filterableEntriesContext;
  status = stub->GetFilterableEntries(&filterableEntriesContext, filterableEntriesReq, &filterableEntriesReply);

  if (!status.ok()) {
    std::cerr << "Error getting filterable entries: " << status.error_message() << std::endl;
  } else {
    std::cout << "FilterableEntries" << filterableEntriesReply.DebugString() << std::endl;
  }

  // Send a GetAll request
  AllRequest allReq;
  AllReply allReply;
  ClientContext allContext;
  status = stub->GetAll(&allContext, allReq, &allReply);

  if (!status.ok()) {
    std::cerr << "Error getting all: " << status.error_message() << std::endl;
  } else {
    std::cout << "All" << allReply.DebugString() << std::endl;
  }

  // Send a GetMenu request
  MenuRequest menuReq;
  MenuReply menuReply;
  ClientContext menuContext;
  status = stub->GetMenu(&menuContext, menuReq, &menuReply);

  if (!status.ok()) {
    std::cerr << "Error getting menu: " << status.error_message() << std::endl;
  } else {
    std::cout << "menu" << menuReply.DebugString() << std::endl;
  }

  // Send a GetMenu request
  FoodRequest foodReq;
  FoodReply foodReply;
  ClientContext foodContext;
  status = stub->GetFood(&foodContext, foodReq, &foodReply);

  if (!status.ok()) {
    std::cerr << "Error getting food " << status.error_message() << std::endl;
  } else {
    std::cout << "food" << foodReply.DebugString() << std::endl;
  }

  return 0;
}