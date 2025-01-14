class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.2/smartmontools-7.2.tar.gz"
  sha256 "5cd98a27e6393168bc6aaea070d9e1cd551b0f898c52f66b2ff2e5d274118cd6"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "9cccb94c747cd2897d458da6a31c2e5c03acfd81faa30c99260fe77ec8c140f0" => :big_sur
    sha256 "27f51cc884f31b7ba77754294e701a9a219e06e8070d4e7630310cf1d01c0b1e" => :arm64_big_sur
    sha256 "34aa008976f95dc5568c90c0b99eccdcec7983df3787ac4be1e02284f307c1e7" => :catalina
    sha256 "3f699e7deb392d47d805cf4dad81e53cf67fe0186b00f42e798235fa9079f388" => :mojave
    sha256 "1019492712285b9342e1a56f53a794d95b00ca023b4df044e8143275c8c4d893" => :x86_64_linux
  end

  def install
    (var/"run").mkpath
    (var/"lib/smartmontools").mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-savestates",
                          "--with-attributelog"
    system "make", "install"
  end

  test do
    system "#{bin}/smartctl", "--version"
    system "#{bin}/smartd", "--version"
  end
end
