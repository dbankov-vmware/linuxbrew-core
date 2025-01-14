class Bbe < Formula
  desc "Sed-like editor for binary files"
  homepage "https://sourceforge.net/projects/bbe-/"
  url "https://downloads.sourceforge.net/project/bbe-/bbe/0.2.2/bbe-0.2.2.tar.gz"
  sha256 "baaeaf5775a6d9bceb594ea100c8f45a677a0a7d07529fa573ba0842226edddb"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "677a07ce2e73761b8403033706a969d15bd89f98401054dccae350c0d9acdf6b" => :big_sur
    sha256 "7181a956a065ea4b793431041e45cc04d217a7c64a579dcf1c7078249ee579ab" => :arm64_big_sur
    sha256 "16ec8602703755894016b9ecd47ca9875a97c66ba259cdb8d7fa8902a17dd8d3" => :catalina
    sha256 "f1c5c6884c5e1740d5f649ac1caa4bb42df1a5ab6bba13970497f7c94454d346" => :mojave
    sha256 "95cef154264d814bcdb543da64b8947ed8219411c3da20d854f30bd0aeb1332a" => :high_sierra
    sha256 "4f533ae33e0c46a01bc11f1c8b99ef6baba62a376ddee1000de1fa199f18545a" => :sierra
    sha256 "d9c63d7b9657e6f1c0e53048564f275283177e3513e202a7a9cfc69571bb5008" => :el_capitan
    sha256 "ae0aa826fcd9f11e93428e9eaeedb14a56c193c861f09123999a8ba0f3d7f9cd" => :yosemite
    sha256 "6b7c4c2c05ab444212260dfef6b2ab2ed7e9230844007651217259d1f957ed02" => :mavericks
    sha256 "ab60278e8805481ca3a130113a209d80fa06df1069af1f3c750ded36844b3d74" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bbe", "--version"
  end
end
