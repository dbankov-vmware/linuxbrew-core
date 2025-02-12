class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v3.0.0.tar.gz"
  sha256 "ea5183f285930ffa4014d54d4ed80ac8f7aa9afd1114e5fce6e65f2e9ed1af0c"
  license "MIT"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d28ce78d9de727b84a069328160ec719db14789645e6088d67eeab462085722" => :big_sur
    sha256 "7cdbcf9ca2bf59f73b8dad9d409410bc49c5e682def3025b543d57ec29ab88ac" => :arm64_big_sur
    sha256 "6e28a27d6d1c24b2cd7d3ca0ff147a8309425dcd1d405861378bd40c191af5d2" => :catalina
    sha256 "246a6e46d12ceb79f4406802a72860a4d4e381bf34b8228c10773898b33dbb3e" => :mojave
    sha256 "24f80eafb9d738391a99724915f07a546ebc822d5e3ab725fc90bfa690cc4ee7" => :high_sierra
    sha256 "fdd37416a9eb4d04734b586477651b275adbcb01d6060bda18e47fc4a75e815e" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"vaulted", "."
    man1.install Dir["doc/man/vaulted*.1"]
  end

  test do
    (testpath/".local/share/vaulted").mkpath
    touch(".local/share/vaulted/test_vault")
    output = IO.popen(["#{bin}/vaulted", "ls"], &:read)
    output == "test_vault\n"
  end
end
