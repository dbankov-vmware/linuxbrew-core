class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.2.5",
      revision: "0b2fea55ff992acd69b6840ddad7f08d4ef28574"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a5c9c6a3132942741bc69ed57081a38570f783f316a5b922d20ee6c16efa4a2" => :big_sur
    sha256 "327c9a2fd0832a249576f27df06fa4b8b32e370e9bf624b862198d2fcb2da531" => :arm64_big_sur
    sha256 "13a6c59ba4c19570fcccef4b187755a4dfcc26038faba5168a3eb33644ade588" => :catalina
    sha256 "0aeae5e296d00a1b00a53b6a5b9c9aea39731826ea882e3adb51e51bd3fed653" => :mojave
    sha256 "14b39018ed3d1fa076250354d86e3f9296de24bd5a57144cd265666cbe29a6ee" => :high_sierra
    sha256 "9c52faa573edce1a1831d112c24daa6bcfd3cde7a2d3bc25c74bcda84c9dc9fd" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"whalebrew", "."
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    if File.exist?("/var/run/docker.sock") && ENV["CI"]
      assert_match "Unable to find image", output
    else
      assert_match "Cannot connect to the Docker daemon", output
    end
  end
end
