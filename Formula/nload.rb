class Nload < Formula
  desc "Realtime console network usage monitor"
  homepage "http://www.roland-riegel.de/nload/"
  url "http://www.roland-riegel.de/nload/nload-0.7.4.tar.gz"
  sha256 "c1c051e7155e26243d569be5d99c744d8620e65fa8a7e05efcf84d01d9d469e5"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?nload[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "497154bd3de08b44994d05c69467266bb5ea54e6ddb7c9353bbf63bc77463447" => :big_sur
    sha256 "2c5db3ac98383bf71154283dbca344ef7e4ac355338bdff337936cb4836b8ace" => :arm64_big_sur
    sha256 "2e566035d80abd97c43955ac5fa05ba347b67dbbd10d0543faef3cf5cc7b0bfb" => :catalina
    sha256 "1dbf614f22611f66ee49efa6b1f5a1af29066be04e461d56e9766b84aeb68077" => :mojave
    sha256 "3bcdee6e4f2e404d0ec728620b025524de265f94fccc290b29fc81f04f85be36" => :high_sierra
    sha256 "a142f2d9f70c0686669f5d744b986ee3244ee29274d30e8471ca176d4361317d" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  # crash on F2 and garbage in adapter name, see https://sourceforge.net/p/nload/bugs/8/ reported on 2014-04-03
  patch :p0 do
    url "https://sourceforge.net/p/nload/bugs/_discuss/thread/c9b68d8e/4a65/attachment/devreader-bsd.cpp.patch"
    sha256 "19055158b72722f7dabff9890931094cac591bcc6de3e90a7f4744d28746ebc7"
  end

  # Patching configure.in file to make configure compile on Mac OS.
  # Patch taken from MacPorts.
  patch :DATA

  def install
    system "./run_autotools"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
  end

  test do
    system "#{bin}/nload", "--help"
  end
end


__END__
diff --git a/configure.in b/configure.in
index 87ecc88..4df8dc3 100644
--- a/configure.in
+++ b/configure.in
@@ -38,7 +38,7 @@ case $host_os in
 
         AC_CHECK_FUNCS([memset])
         ;;
-    *bsd*)
+    *darwin*)
         AC_DEFINE(HAVE_BSD, 1, [Define to 1 if your build target is BSD.])
         AM_CONDITIONAL(HAVE_BSD, true)
