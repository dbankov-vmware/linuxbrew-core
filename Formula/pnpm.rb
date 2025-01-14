class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.14.3.tgz"
  sha256 "eec8d806e77f8726098dfde69877e70f60eb7349cf1a5004346b16ecce72d44a"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7ad15e088f7c1c3002eb019f8bd565639dd13e0a21db279ea083109ea78f5bfe" => :big_sur
    sha256 "ebd1c5a17e63b2ba3be01513b96aa57a85b236f2cde86ac2b781234c07a3c1d5" => :arm64_big_sur
    sha256 "dc69643947d74bef478404ae1ac2f0a429418fad05f53d4e635c3eb9f62dbe39" => :catalina
    sha256 "4e41b149cb110be282af9dc86d9323c3336ffaf3e2bc16261a9ee1329e02136b" => :mojave
    sha256 "5b297321334d67d7a55a5805cc09cf94fdc0c86623f460c67308d3bd767674e9" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
