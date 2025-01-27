class Libdmx < Formula
  desc "X.Org: X Window System DMX (Distributed Multihead X) extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libdmx-1.1.4.tar.bz2"
  sha256 "253f90005d134fa7a209fbcbc5a3024335367c930adf0f3203e754cf32747243"
  license "MIT"

  bottle do
    cellar :any
    sha256 "e5d9c7b5d007505a52338b9d901576fa407af1bc802ee392412b81e0266be641" => :big_sur
    sha256 "c9aae9326ce9a74e1082a3af3678b61694a90c8e360bcdf4b78c369be0ff95bf" => :arm64_big_sur
    sha256 "89fc7b694d6e0d2bd786f053bf9f8bb8aa2005f99319e6a75fad30dfcff7b831" => :catalina
    sha256 "53a22f968698ff43bd3e483a77cc1c1a1b9bcc4ef3cbdfc6ffa5039d7e6af6b1" => :mojave
    sha256 "d4b4e652d95db58f17afbf8d061cc161982b3726da03f403a05c14c8b99558a4" => :high_sierra
    sha256 "cd51443dfbb6d29d55764a4b9679be0b850ba2500b756c6f75df412ba761d2c7" => :x86_64_linux
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
      #include "X11/Xlib.h"
      #include "X11/extensions/dmxext.h"

      int main(int argc, char* argv[]) {
        DMXScreenAttributes attributes;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
