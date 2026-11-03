class Vericto < Formula
  desc "Validate SQL against your Vericto workspace's security rules before it runs"
  homepage "https://vericto.com"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.0.0/vericto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7b26859f8238d2601e94d119add44a7457bf38a59c437d85fe039ead46264573"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.0.0/vericto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "24f8d858f808026cb559bc7f56db6ca730876ff436a7a39ac83d0fc1e0ec62da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.0.0/vericto-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "12472b953de55c8ce9bdf71a0d1dc2871ea78d8ed3c3c6e99d122afa849a4ce5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vericto/vericto-cli/releases/download/v2.0.0/vericto-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "56c675559029ea36e3c3e337a3e98cd75326bb71b495064e1028f3991016ccc2"
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
