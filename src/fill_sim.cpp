#include <iostream>

#ifdef _WIN32
    // On Windows, use stub if Fix8 is not available
    #ifdef FIX8_AVAILABLE
        #include <fix8/f8config.h>
    #else
        #include "../include/fix8_stub.hpp"
        #ifdef _MSC_VER
            #pragma message("Using Fix8 stub - full Fix8 functionality not available")
        #else
            #warning "Using Fix8 stub - full Fix8 functionality not available"
        #endif
    #endif
#else
    // On Unix-like systems, use full Fix8
    #include <fix8/f8config.h>
#endif

int main()
{
    std::cout << "[fill_sim] Running minimal FIX8 fill simulator..." << std::endl;
    
#ifdef FIX8_AVAILABLE
    std::cout << "[fill_sim] Full Fix8 functionality available" << std::endl;
#else
    std::cout << "[fill_sim] Running with stub implementation" << std::endl;
#endif
    
    return 0;
}
