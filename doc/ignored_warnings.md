# Suppressed Compiler Warnings (Fix8 Engine)

These warnings are suppressed because they are:
- Harmless in context (no undefined behavior)
- Triggered by optimization patterns (e.g., memcpy on trivially copyable structs)
- Coming from third-party Fix8 library headers

**Note:** Warnings from Fix8 library build process (using automake/autoconf) cannot be suppressed 
via CMake flags. The suppressions below only apply to our project's compilation when using Fix8 headers.

| Flag | Reason |
|------|--------|
| `-Wno-class-memaccess` | Triggered by `memcpy` to `FieldTrait`, which is safe due to POD-like structure. |
| `-Wno-unused-result`   | Triggered by `std::string::empty()` result being ignored in regex utils. |
| `-Wno-overloaded-virtual` | Fix8 Router virtual function hiding pattern is intentional. |
| `-Wno-deprecated-declarations` | Fix8 uses `pthread_yield()` which is deprecated but still functional. |
