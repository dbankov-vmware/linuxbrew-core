class Heatshrink < Formula
  desc "Data compression library for embedded/real-time systems"
  homepage "https://github.com/atomicobject/heatshrink"
  url "https://github.com/atomicobject/heatshrink/archive/v0.4.1.tar.gz"
  sha256 "7529a1c8ac501191ad470b166773364e66d9926aad632690c72c63a1dea7e9a6"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "9131daef95de9b3c7fecb082ade54be4b67f8c4ca3f3bce6d18f19b1492078d9" => :big_sur
    sha256 "a6a1ec3b2cd5dc0ebc16fe7ed2beabdb2aba1c7fd9782d3d7fe5f667f4298b44" => :arm64_big_sur
    sha256 "5956959544286fc9b6474a0f6df508530431c1632527fa4048091f33f319fab2" => :catalina
    sha256 "504b4b64164343217c6852509b59858494ba38ad9b63e7a9b3bb247290833582" => :mojave
    sha256 "865d11380a3e586a962a5dec0069def43e777f20626bdc5396735d003d90d20b" => :high_sierra
    sha256 "3965350f672040dfec9d2e07ac5f26aa16b324f59d2a762a4faac0930d2de684" => :sierra
    sha256 "e123eeaf3cb1a91fee75c354d7655e81a3f1352d9dae4f4b5797cf7dbe3d00f9" => :x86_64_linux
  end

  def install
    mkdir_p prefix/"bin"
    mkdir_p prefix/"include"
    mkdir_p prefix/"lib"
    system "make", "test_heatshrink_dynamic"
    system "make", "test_heatshrink_static"
    system "make", "install", "PREFIX=#{prefix}"
    (pkgshare/"tests").install "test_heatshrink_dynamic", "test_heatshrink_static"
  end

  test do
    system pkgshare/"tests/test_heatshrink_dynamic"
    system pkgshare/"tests/test_heatshrink_static"
  end
end
