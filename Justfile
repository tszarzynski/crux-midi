default: check

# fmt check, clippy (pedantic + nursery), tests, and the no_std build
check:
    cargo fmt --check
    cargo clippy --all-targets -- -D warnings
    cargo test
    cargo build --no-default-features --features crux_core/critical-section --target thumbv7em-none-eabihf
