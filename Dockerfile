FROM rust:latest

RUN rustup default nightly

RUN rustup target add x86_64-fortanix-unknown-sgx --toolchain nightly 

RUN apt-get update && apt-get install pkg-config libssl-dev protobuf-compiler -y

RUN cargo install fortanix-sgx-tools sgxs-tools

# Set the working directory inside the container
WORKDIR /app

# Copy your Rust enclave application files
COPY . /app

# Build the enclave application using ftxsgx-runner-cargo
RUN cargo build --target x86_64-fortanix-unknown-sgx --release
RUN openssl genrsa -3 3072 > my_key.pem
RUN sgxs-sign --key my_key.pem ./target/x86_64-fortanix-unknown-sgx/release/test_sgx.sgxs test_sgx.sig -d --xfrm 7/0 --isvprodid 0 --isvsvn 0

# Run your enclave application when the container starts
CMD ["ftxsgx-runner", "./target/x86_64-fortanix-unknown-sgx/release/test_sgx.sgxs"]


## Another approach would be just to create a docker image with the environment needed to execute the application
## and then copy the compiled app inside to run directly 
