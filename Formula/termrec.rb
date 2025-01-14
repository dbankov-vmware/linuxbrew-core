class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/v0.19.tar.gz"
  sha256 "0550c12266ac524a8afb764890c420c917270b0a876013592f608ed786ca91dc"
  license "LGPL-3.0"
  head "https://github.com/kilobyte/termrec.git"

  bottle do
    cellar :any
    sha256 "81060090e19bbb56f0b991dfa987eb890c00b116b656be2d2bd29ea027f9496a" => :big_sur
    sha256 "a03a052b7ee89450b145a866724f6f97727c56bbf0220a14a089c84951aeed35" => :arm64_big_sur
    sha256 "1d93149ec34c0bf531da76b0137390ed1f05bf2e35e806f1fe875fe6648c4c2b" => :catalina
    sha256 "e3f9f241763a05de367da2ee91727674e18a126a99480a750b901a21bdad0ffb" => :mojave
    sha256 "d6cb43ed14ec0531824bd4eb55ddc625b5711c28b274ce78eb815501e5f3ebf2" => :high_sierra
    sha256 "8e69b3b9c275945b60d2e67ab8b165ce485de75c372a76f321f7579878b229c6" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/termrec", "--help"
  end
end
