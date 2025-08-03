#pragma once

// Minimal Fix8 stub for Windows development
// This allows the project to compile without the full Fix8 library

namespace FIX8 {
    // Add minimal stubs as needed
    class Session {
    public:
        virtual ~Session() = default;
    };
}

// Minimal compatibility defines
#define FIX8_NAMESPACE FIX8
