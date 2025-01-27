class Libxscrnsaver < Formula
  desc "X.Org: X11 Screen Saver extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXScrnSaver-1.2.3.tar.bz2"
  sha256 "f917075a1b7b5a38d67a8b0238eaab14acd2557679835b154cf2bca576e89bf8"
  license "MIT"

  bottle do
    cellar :any
    sha256 "76e43f0d5a786ac9f6689e2c02956a8519e512dca746f882403fbec960e4291f" => :big_sur
    sha256 "a7e75a15ac1d4fc2b9dd81a0d0bcb5ae1ff457c52ad5440938e5c3ccc4b6289e" => :arm64_big_sur
    sha256 "d90c91c9058ec7f2bcac9b2b9b83a5dd76096acd88d09c93edee9abaa02707a5" => :catalina
    sha256 "f57eb48a438ab0556e3401ba7b0b049392d11faa2de214ab533e9d444cbf65f2" => :mojave
    sha256 "44c025315c63c131e89f1fbb4949a0bae4b56bc76ea9e2db320c058e245a3e43" => :high_sierra
    sha256 "e2d880890f7b7a4df804c3ad575247d6a4d4eecfc7314bba90405f49c4b25b3d" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/scrnsaver.h"

      int main(int argc, char* argv[]) {
        XScreenSaverNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
