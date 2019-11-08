#include <fstream>
#include <google/protobuf/text_format.h>
#include <grpcpp/grpcpp.h>
#include <iostream>
#include <string>

#include "proto/mdining.grpc.pb.h"
#include "proto/mdining.pb.h"

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using grpc::StatusCode;
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

template <typename Proto>
bool ReadTextProto(const std::string &file, Proto *proto) {
  std::ifstream ifs(file);
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));
  return google::protobuf::TextFormat::ParseFromString(content, proto);
}

class MDiningServiceImpl final : public MDining::Service {
public:
  MDiningServiceImpl()
      : diningHallsReply(new DiningHallsReply), itemsReply(new ItemsReply),
        filterableEntriesReply(new FilterableEntriesReply),
        allReply(new AllReply) {
    if (!ReadTextProto("proto/sample/dininghalls.proto.txt",
                       diningHallsReply.get()) ||
        !ReadTextProto("proto/sample/items.proto.txt", itemsReply.get()) ||
        !ReadTextProto("proto/sample/filterableentries.proto.txt",
                       filterableEntriesReply.get())) {
      std::cerr << "Could not read text proto" << std::endl;
      exit(1);
    }
    // Initialize allReply by copying in diningHallsReply, itemsReply and
    // filterableEntriesReply fields
    for (int i = 0; i < diningHallsReply->dininghalls_size(); i++) {
      *allReply->add_dininghalls() = diningHallsReply->dininghalls(i);
    }
    *allReply->mutable_items() = itemsReply->items();
    for (int i = 0; i < filterableEntriesReply->filterableentries_size(); i++) {
      *allReply->add_filterableentries() =
          filterableEntriesReply->filterableentries(i);
    }
  }

  Status GetDiningHalls(ServerContext *context,
                        const DiningHallsRequest *request,
                        DiningHallsReply *reply) override {
    std::cout << "Serving GetDiningHalls" << std::endl;
    *reply = *diningHallsReply;
    return Status::OK;
  }

  Status GetItems(ServerContext *context, const ItemsRequest *request,
                  ItemsReply *reply) override {
    std::cout << "Serving GetItems" << std::endl;
    *reply = *itemsReply;
    return Status::OK;
  }

  Status GetFilterableEntries(ServerContext *context,
                              const FilterableEntriesRequest *request,
                              FilterableEntriesReply *reply) override {
    std::cout << "Serving GetFilterableEntries" << std::endl;
    *reply = *filterableEntriesReply;
    return Status::OK;
  }

  Status GetAll(ServerContext *context, const AllRequest *request, AllReply *reply) override {
    std::cout << "Serving GetAll" << std::endl;
    *reply = *allReply;
    return Status::OK;
  }

  Status GetMenu(ServerContext *context, const MenuRequest *request, MenuReply *reply) override {
    std::cout << "Serving GetMenu " << request->date() << " " << request->meal() << " " << request->dininghall() << std::endl;
    return Status(StatusCode::UNIMPLEMENTED, "GetMenu has not been implemented");
  }

  Status GetFood(ServerContext *context, const FoodRequest *request, FoodReply *reply) override {
    std::cout << "Serving GetFood " << request->date() << " "  << request->date() << std::endl;
    return Status(StatusCode::UNIMPLEMENTED, "GetFood has not been implemented");
  }

private:
  std::unique_ptr<DiningHallsReply> diningHallsReply;
  std::unique_ptr<ItemsReply> itemsReply;
  std::unique_ptr<FilterableEntriesReply> filterableEntriesReply;
  std::unique_ptr<AllReply> allReply;
};

void RunServer() {
  std::string server_address("localhost:50051");
  MDiningServiceImpl service;

  ServerBuilder builder;
  // Listen on the given address without any authentication mechanism.
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  // Register "service" as the instance through which we'll communicate with
  // clients. In this case it corresponds to an *synchronous* service.
  builder.RegisterService(&service);
  // Finally assemble the server.
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;

  // Wait for the server to shutdown. Note that some other thread must be
  // responsible for shutting down the server for this call to ever return.
  server->Wait();
}

int main() {
  RunServer();
  return 0;
}
