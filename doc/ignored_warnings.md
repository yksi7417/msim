# Suppressed Compiler Warnings (Fix8 Engine)

These warnings are suppressed because they are:
- Harmless in context (no undefined behavior)
- Triggered by optimization patterns (e.g., memcpy on trivially copyable structs)

| Flag | Reason |
|------|--------|
| `-Wno-class-memaccess` | Triggered by `memcpy` to `FieldTrait`, which is safe due to POD-like structure. |
| `-Wno-unused-result`   | Triggered by `std::string::empty()` result being ignored in regex utils. |
