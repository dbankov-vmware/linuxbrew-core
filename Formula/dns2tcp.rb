class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "https://packages.debian.org/sid/dns2tcp"
  url "https://deb.debian.org/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"
  license "GPL-2.0"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dns2tcp/"
    regex(/href=.*?dns2tcp[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "09b03661d759932c928ae63c72af41a528f6378d6f23e67e0341592ecba34a47" => :big_sur
    sha256 "7342bad79a49f0cd2049fe73e9545ae691d83087e285d97b926bd3e29b7f0643" => :arm64_big_sur
    sha256 "f1517166d8e8e02dbefbb654214012a6bf089ab78a1a237c9ec7d86c356da97f" => :catalina
    sha256 "f44f4f2e761da51c4552b6c394ae3ee48e2c1ff8b1b506cf35e648b3331b49dd" => :mojave
    sha256 "d6fb240175854e0a0b5069544a58c4fbcd161d3337288c2f289f48999c4dde10" => :high_sierra
    sha256 "e948ddde1e95f055a9cd3e73cd2756c22f729d9feed9ebc2929cb3df6fe09584" => :sierra
    sha256 "2cd5e77bec42f0f5e2715494c38eb8773ab30d53b140509d3f428d38890bf640" => :el_capitan
    sha256 "3e805ac804eea824b81bd15191b71cdc42d4ac779ebfc1d74d5de51500be18a5" => :yosemite
    sha256 "2f69efb2f705eb1514e8b46d7daa61379df3f4892cfe2d570c233a18ff109e7d" => :mavericks
    sha256 "29555ccb8cdf2fba7bfc8807ff887b4494f4858c100248f0c680f4e6c0194702" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match(/^dns2tcp v#{version} /,
                 shell_output("#{bin}/dns2tcpc -help 2>&1", 255))
  end
end
