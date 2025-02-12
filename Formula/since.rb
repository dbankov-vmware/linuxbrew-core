class Since < Formula
  desc "Stateful tail: show changes to files since last check"
  homepage "http://welz.org.za/projects/since"
  url "http://welz.org.za/projects/since/since-1.1.tar.gz"
  sha256 "739b7f161f8a045c1dff184e0fc319417c5e2deb3c7339d323d4065f7a3d0f45"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "60c3738e71c6455fa5a7445a21a79695d4644a34de06cbc05743a52c4f5b40f8" => :big_sur
    sha256 "95b9b96522d9cdb0ac317550daf1c9ee102d1a4df7736cd2072d896adf05fc04" => :arm64_big_sur
    sha256 "20b3f4888282ed47021562eb24efe9c37ef3a652ad64164460a5f368260e75d8" => :catalina
    sha256 "6c0290f3500966bb4155352bf277ae127eb341796729dfcc2b9ca968df20b9c4" => :mojave
    sha256 "a5b4f42858c41ad5d60850a3a01b8658fb4e58d2473fe2d36938f4ab66eb05c6" => :high_sierra
    sha256 "ff4ba4b7cad5fa4211bff04d5868521bc21b60995cf40f15bd507abb7c4cbaab" => :sierra
    sha256 "ec4898462899cb632329f71dc0b4dd9a13a051aafd6da7dfd22e940e9d1ce01a" => :el_capitan
    sha256 "e92218f17ac1926f4651b3e70d3fe42d43b7024e1f10d0ab6f1c7c9dd6bad606" => :yosemite
    sha256 "bfd7889688facdf732cf0bf2bb8c7a917df71e80615a5f367468708437c0519e" => :mavericks
    sha256 "606f75f34e3690b1f38dfbe519ac9362e91ef226aaeac62840ff00fc11561de1" => :x86_64_linux
  end

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "prefix=#{prefix}", "INSTALL=install"
  end

  test do
    (testpath/"test").write <<~EOS
      foo
      bar
    EOS
    system "#{bin}/since", "-z", "test"
    assert_predicate testpath/".since", :exist?
  end
end
