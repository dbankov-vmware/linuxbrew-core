class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.3.2.tar.gz"
  sha256 "66d44dd6af485b2b003b0aa1c8dcd799f7bae934f1ce1efb7e5d5f6cfe7f8bf2"
  license "MIT"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9cb9c7fed6faa3b485837ed36a486ff1950f18230575955bf73d7126fb7d367" => :big_sur
    sha256 "77242b02131a4acb61a6e7ba53ce10aff21fa87da8fe9fd9f8e735ebc33b2712" => :arm64_big_sur
    sha256 "a74e94857f4b788918ac74f9ef20c3c6c19a0e1164522a4591165b0d070795a4" => :catalina
    sha256 "d24e802f1fc572c7d49620531e57a5e143956b2ce1e1d05b2320167b09fbf875" => :mojave
    sha256 "aac8b68119dad48d8aca16a2355cc5c8605e8b1fe44b18e5eb8326216873d657" => :high_sierra
    sha256 "1d22caa158fea3cb67ca07ef5f0785dc9f8568470d0323a5958229ed1f650f6c" => :sierra
    sha256 "dee372222a33f4899284601dac11ddbcdb27825752a3a6c54c28712e56e7b3d5" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/99designs/iamy"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"iamy", "-ldflags",
             "-X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"
    output = shell_output("#{bin}/iamy pull 2>&1", 1)
    assert_match "Can't determine the AWS account", output
  end
end
