class Hesiod < Formula
  desc "Library for the simple string lookup service built on top of DNS"
  homepage "https://github.com/achernya/hesiod"
  url "https://github.com/achernya/hesiod/archive/hesiod-3.2.1.tar.gz"
  sha256 "813ccb091ad15d516a323bb8c7693597eec2ef616f36b73a8db78ff0b856ad63"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8b396dffcf3d833f50169ee20ae3ae126775cb40430ee4d2d967ba459834815a" => :big_sur
    sha256 "66f05bed0ecbd7328400f142a7864ec972fd3573d284375c222ff963a5ae7875" => :arm64_big_sur
    sha256 "2e077b355ca0ed9f0bbadfc7b54ef681fc11f58c324ce19d3131fb61b99f15d2" => :catalina
    sha256 "76748e285f22aed694c2933e4cd3a1469398ea254671755e6f89ad07e76b7f73" => :mojave
    sha256 "de927a6526209db3673aa9e426d7e32f53b7a278798f07d6dc1c5069e816d09a" => :high_sierra
    sha256 "0d9ae63a2b02aec55126fb87cde0bd50c4032f6f644f78fc2d1a17c99ea7f292" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libidn"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hesinfo", "sipbtest", "passwd"
    system "#{bin}/hesinfo", "sipbtest", "filsys"
  end
end
