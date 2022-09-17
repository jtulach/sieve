# Running Rust

Best way to install Rust would be using rustup (see your distro repository, or `https://rustup.rs`), it allows to install specific toolchains/rust versions, which might be important to match LLVM version with GraalVM.

Toolchain installation:
```sh
rustup toolchain install stable
rustup toolchain install 1.63
```

Then you can run the code just being in this directory:
```sh
cargo run --release
cargo +1.63 run --release
```
(don't forget the release flag, unoptimized code can be more than 10 times slower with rust)

# Running Rust with GraalVM
The code is tested with specific versions:
- rust 1.63
- GraalVM EE Native 22.2.0
	- it is not LTS version, because previous versions don't work with rust's standard main function.
	- Though it is possible to start rust code using C-like main function without additional problems (see `#![no_main]`).

With other versions it is advisable to match LLVM versions:
```sh
rustc +1.63 --version --verbose
$GRAALVM/bin/lli --version
```

Running Rust under GraalVM should then be simple:
```sh
cargo +1.63 rustc --release -- --emit=llvm-bc
$GRAALVM/bin/lli --lib (rustc +1.63 --print sysroot)/lib/libstd-* $RUST/target/release/deps/rust-*.bc
```
(in case of tinkering, you might want to check that there is only one `rust-*.bc` file)


# Workarounds

## std::time::Instant
Usage of time measurements in std result in `com.oracle.truffle.api.CompilerDirectives$ShouldNotReachHere` with exact stack trace changing between GraalVM/Rust versions.

Unclear why, the reimplementation in `time.rs` uses exact same call to libc as `std::time::Instant` would.

## Unsuported instructions
- `llvm.smul.with.overflow.i128` et al. are problematic only in debug mode which would normally panic on overflow. Fixed by using wrapping instructions.
- `llvm.fptoui.sat.i32.f64` inability to convert floats to ints complicates `sqrt` computation -> `int_sqrt.rs`.

# Performance oddities
(All times are on the same machine, unspecified, only relative times are important)

Using `cargo +1.63 run --release` one loop of 100 000 primes is completed in ~65 ms.

GraalVM (EE Native 22.2.0) gives nondeterministic times. It converges to either ~100 ms or ~250 ms per loop, even with the exact same bitcode without rerunning:
```cargo +1.63 rustc --release -- --emit=llvm-bc```
