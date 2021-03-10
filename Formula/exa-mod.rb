class ExaMod < Formula
  desc "Modern replacement for 'ls' (modified version)"
  homepage "https://the.exa.website"
  version "unstable-2021-01-14"
  url "https://github.com/ogham/exa.git",
    revision: "13b91cced4cab012413b25c9d3e30c63548639d0"
  license "MIT"

  bottle do
    root_url "https://github.com/kidonng/homebrew-malt/releases/download/exa-mod-unstable-2021-01-14"
    sha256 cellar: :any_skip_relocation, big_sur: "b0b71a69498aa413aaeaf2d6b05f95f46bf697c9870a9dff07dbfb310371e949"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  conflicts_with "exa", because: "both install `exa` binary"

  # Support reading arguments from config file and environment variables
  # https://github.com/ogham/exa/pull/763
  patch do
    url "https://github.com/ogham/exa/pull/763.patch?full_index=1"
    sha256 "c8d9d39571f78bab0abf3bee91fd3c38e6a433cbd4e6cf7fa46e231af10fe4c6"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/completions.bash" => "exa"
    zsh_completion.install  "completions/completions.zsh"  => "_exa"
    fish_completion.install "completions/completions.fish" => "exa.fish"

    args = %w[
      --standalone
      --to=man
    ]

    system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
    system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"

    man1.install "exa.1"
    man5.install "exa_colors.5"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
