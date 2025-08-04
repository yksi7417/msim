#pragma once

// Minimal Fix8 stub for Windows development
// This allows the project to compile without the full Fix8 library

#include <string>
#include <memory>
#include <iostream>

namespace FIX8 {
    // Forward declarations
    class Message;
    class Configuration;
    
    // Minimal session stub
    class Session {
    public:
        Session() = default;
        virtual ~Session() = default;
        
        virtual bool start() { 
            std::cout << "[STUB] Session::start() called" << std::endl;
            return true; 
        }
        virtual void stop() { 
            std::cout << "[STUB] Session::stop() called" << std::endl;
        }
        virtual bool send(const Message& msg) { 
            std::cout << "[STUB] Session::send() called" << std::endl;
            return true; 
        }
    };
    
    // Minimal message stub
    class Message {
    public:
        Message() = default;
        virtual ~Message() = default;
        
        virtual std::string to_string() const { 
            return "[STUB] Message content"; 
        }
    };
    
    // Minimal configuration stub
    class Configuration {
    public:
        Configuration(const std::string& config_file) : config_file_(config_file) {
            std::cout << "[STUB] Configuration loaded from: " << config_file << std::endl;
        }
        
    private:
        std::string config_file_;
    };
    
    // Server session stub
    class ServerSession : public Session {
    public:
        ServerSession(const Configuration& config) : config_(config) {
            std::cout << "[STUB] ServerSession created" << std::endl;
        }
        
        bool start() override {
            std::cout << "[STUB] ServerSession::start() - listening for connections" << std::endl;
            return true;
        }
        
    private:
        const Configuration& config_;
    };
    
    // Client session stub  
    class ClientSession : public Session {
    public:
        ClientSession(const Configuration& config) : config_(config) {
            std::cout << "[STUB] ClientSession created" << std::endl;
        }
        
        bool start() override {
            std::cout << "[STUB] ClientSession::start() - connecting to server" << std::endl;
            return true;
        }
        
    private:
        const Configuration& config_;
    };
}

// Minimal compatibility defines
#define FIX8_NAMESPACE FIX8
