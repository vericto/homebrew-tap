class Vericto < Formula
  desc "Validate SQL against your Vericto workspace's security rules before it runs"
  homepage "https://vericto.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.4.0/vericto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b1f4b2522ba93f41abc295de3c63c1e2da9b9ff2b263213b9794f570a893e161"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.4.0/vericto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2c2289759150c0c446d6a648b02ecac6cde26e04f7466302ddc2d11c77ba1d63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.4.0/vericto-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fd08401e4e8b05361154726e54282d0b0bd4323996825c07cd51637758b18909"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.4.0/vericto-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e3a579e216e7bea3f0079a3d9aa329444769c4e613e3910a94858876e869983b"
    end
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
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
