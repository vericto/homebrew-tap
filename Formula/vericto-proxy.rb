class VerictoProxy < Formula
  desc "Database guardrails for AI agents: TCP proxy and MCP server that check SQL"
  homepage "https://vericto.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.2.0/vericto-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "2f6e1afd0a0d5dc64b1f01c238ee43670bc44dc77e5fc0406873f0dd74005764"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.2.0/vericto-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "7c7e136917b64928bddfdda70b521867470a130f6f5b0f86e6e7a8f5cd498485"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.2.0/vericto-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "32d193bdcf17ef48969c06810ddd1c1642238affc7d01ecf4301d205eddfeb22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.2.0/vericto-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d490007b24dac5dd1697ff6f8bd8c2486a1ebd6113e707964b9bed1146fd979"
    end
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "vericto-proxy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vericto-proxy"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vericto-proxy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vericto-proxy"
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
    assert_match version.to_s, shell_output("#{bin}/vericto-proxy --version")
  end
end
