class Vericto < Formula
  desc "Validate SQL against your Vericto workspace's security rules before it runs"
  homepage "https://vericto.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.8.2/vericto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d9e102800f5c7be92fbf4eda42831d9405d425f8fea2ded05347852440d9d8d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.8.2/vericto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f010e025c41fb726acdcffbc09b84c6f3fde24379b45f200161858523fb5c3a0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.8.2/vericto-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "97c0a1c1d8d686f3940598b3961d4e804d841e2a24b6802dbaecfd42f715d490"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.8.2/vericto-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "053a25aea5a9b18a9569a615f9d60ac3d6549056d9b7d2d19bd31dbaadb397a0"
    end
  end
  license "Elastic-2.0"

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
