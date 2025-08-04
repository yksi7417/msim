#include <iostream>
#include <thread>
#include <chrono>

#ifdef _WIN32
    // On Windows, use stub if Fix8 is not available
    #ifdef FIX8_AVAILABLE
        #include <fix8/f8config.h>
        #include <fix8/session.h>
        #include <fix8/message.h>
    #else
        #include "../include/fix8_stub.hpp"
        #warning "Using Fix8 stub - full Fix8 functionality not available"
    #endif
#else
    // On Unix-like systems, use full Fix8
    #include <fix8/f8config.h>
    #include <fix8/session.h>
    #include <fix8/message.h>
#endif

using namespace FIX8;

class TestServer {
public:
    TestServer(const std::string& config_file) : config_(config_file) {
        std::cout << "[SERVER] Initializing test server..." << std::endl;
    }
    
    bool start() {
        std::cout << "[SERVER] Starting FIX8 server session..." << std::endl;
        
#ifdef FIX8_AVAILABLE
        // Real Fix8 server implementation would go here
        server_session_ = std::make_unique<ServerSession>(config_);
#else
        // Stub implementation
        server_session_ = std::make_unique<ServerSession>(config_);
#endif
        
        bool result = server_session_->start();
        if (result) {
            std::cout << "[SERVER] Server started successfully and listening for connections" << std::endl;
        } else {
            std::cout << "[SERVER] Failed to start server" << std::endl;
        }
        
        return result;
    }
    
    void stop() {
        if (server_session_) {
            std::cout << "[SERVER] Stopping server session..." << std::endl;
            server_session_->stop();
            server_session_.reset();
        }
    }
    
private:
    Configuration config_;
    std::unique_ptr<ServerSession> server_session_;
};

class TestClient {
public:
    TestClient(const std::string& config_file) : config_(config_file) {
        std::cout << "[CLIENT] Initializing test client..." << std::endl;
    }
    
    bool connect() {
        std::cout << "[CLIENT] Starting FIX8 client session..." << std::endl;
        
#ifdef FIX8_AVAILABLE
        // Real Fix8 client implementation would go here
        client_session_ = std::make_unique<ClientSession>(config_);
#else
        // Stub implementation
        client_session_ = std::make_unique<ClientSession>(config_);
#endif
        
        bool result = client_session_->start();
        if (result) {
            std::cout << "[CLIENT] Client connected successfully" << std::endl;
        } else {
            std::cout << "[CLIENT] Failed to connect to server" << std::endl;
        }
        
        return result;
    }
    
    bool sendTestMessage() {
        if (!client_session_) {
            std::cout << "[CLIENT] Error: No active session" << std::endl;
            return false;
        }
        
        std::cout << "[CLIENT] Sending test message..." << std::endl;
        
        // Create a test message
        Message test_message;
        bool result = client_session_->send(test_message);
        
        if (result) {
            std::cout << "[CLIENT] Test message sent successfully" << std::endl;
        } else {
            std::cout << "[CLIENT] Failed to send test message" << std::endl;
        }
        
        return result;
    }
    
    void disconnect() {
        if (client_session_) {
            std::cout << "[CLIENT] Disconnecting client session..." << std::endl;
            client_session_->stop();
            client_session_.reset();
        }
    }
    
private:
    Configuration config_;
    std::unique_ptr<ClientSession> client_session_;
};

int main() {
    std::cout << "[INTEGRATION TEST] Starting Fix8 server-client integration test..." << std::endl;
    
#ifdef FIX8_AVAILABLE
    std::cout << "[INTEGRATION TEST] Using full Fix8 implementation" << std::endl;
#else
    std::cout << "[INTEGRATION TEST] Using stub implementation for testing" << std::endl;
#endif
    
    // Initialize server
    TestServer server("etc/fix8.cfg");
    if (!server.start()) {
        std::cerr << "[INTEGRATION TEST] Failed to start server" << std::endl;
        return 1;
    }
    
    // Give server time to start up
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
    
    // Initialize client
    TestClient client("etc/fix8.cfg");
    if (!client.connect()) {
        std::cerr << "[INTEGRATION TEST] Failed to connect client" << std::endl;
        server.stop();
        return 1;
    }
    
    // Give connection time to establish
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
    
    // Send test message
    if (!client.sendTestMessage()) {
        std::cerr << "[INTEGRATION TEST] Failed to send test message" << std::endl;
        client.disconnect();
        server.stop();
        return 1;
    }
    
    // Clean shutdown
    std::cout << "[INTEGRATION TEST] Test completed successfully, shutting down..." << std::endl;
    
    client.disconnect();
    server.stop();
    
    std::cout << "[INTEGRATION TEST] Integration test passed!" << std::endl;
    return 0;
}
