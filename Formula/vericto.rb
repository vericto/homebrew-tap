class Vericto < Formula
  desc "Validate SQL against your Vericto workspace's security rules before it runs"
  homepage "https://vericto.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.0/vericto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "af04fef68f31138a748e320176781b37bc6362f52e7074075f65c09782a06e04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.0/vericto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "64024892b332b6e90347409885ac7917fc82114048705b4eba4ab8984db6cc51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.0/vericto-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "dc8ecc110c1195809241142fd23c6d81f8b9ffc9be556f467e5163a83a5a4e33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v1.10.0/vericto-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5f3292cd1527aa0f1447bfe87e761df83b777588cd778b0ead23fe850cda365c"
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
