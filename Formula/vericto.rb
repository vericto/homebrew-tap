class Vericto < Formula
  desc "Validate SQL against your Vericto workspace's security rules before it runs"
  homepage "https://vericto.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.1/vericto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "87cdb064e08a6c24bfc50f101752e6f8f2dbc033a1f80c34796ec804279fea4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.1/vericto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "37b7ec57498358ebd6ac39ff11eb1a59539ef1735d31a89ba32687abd9b42ee7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.1/vericto-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9a5ef9f4ea4ef9e5b02711db00efac308685a4170870d7fa5f9d5b5d84e2a9ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.1/vericto-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9e7fa8fde9f9b3f41c276c2b4bb7ab67e618901a91ea4a59850e0ad311fdd6b4"
    end
  end
  license "FSL-1.1-ALv2"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vericto"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vericto"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vericto"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vericto"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vericto --version")
  end
end
