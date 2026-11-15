class VerictoProxy < Formula
  desc "Database guardrails for AI agents: TCP proxy and MCP server that check SQL"
  homepage "https://vericto.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.0.2/vericto-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "9285dcd6f10889807a742c2766fced15785f369e6c0756259901076341b6e70f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.0.2/vericto-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "03b8be36f75b4825bc07844feb34417793b7ab0ca44b274dc5b50430e3bda102"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.0.2/vericto-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e9f571c114a19b6f77ea27a6c0650245a60d0a7d5ef5f143e15d9f1bebc95c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-proxy/releases/download/v5.0.2/vericto-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4189e2e4b224092cf2b6bed778199ceea04d2879d5965f1d0338faba23a42f49"
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
