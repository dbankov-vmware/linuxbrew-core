class G2 < Formula
  desc "Friendly git client"
  homepage "https://orefalo.github.io/g2/"
  url "https://github.com/orefalo/g2/archive/v1.1.tar.gz"
  sha256 "bc534a4cb97be200ba4e3cc27510d8739382bb4c574e3cf121f157c6415bdfba"
  license "MIT"
  head "https://github.com/orefalo/g2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08b8c6538687a2994e8e589ed75b64e161e9865b49a039a7b6d622186450350a" => :big_sur
    sha256 "e41e0df4fe1e129acfc132add642219228b9bafafef804ad6528e8a42b3ed7d6" => :arm64_big_sur
    sha256 "e9350d1a2278bc954807b784dd6f34044ba69bcbeef3c91410f4bac9affdc0ca" => :catalina
    sha256 "64107e7e395a373205f8e4953082f90e86736b27c01198836ea3915a40362dc5" => :mojave
    sha256 "172bb101cd40ab61ea7a6ce85798556da5bbb980ae050023e8e8ff9f4d2e2c52" => :high_sierra
    sha256 "6bd5de5c1e1335c1be168bf5eec800c8ac5d0b4d16534a7e686d9c4e8d396417" => :sierra
    sha256 "45c2029c3fc914866ba32966a78cba39b8415ba7f191cd1eaaf604db798b6d3f" => :el_capitan
    sha256 "5645b9c9401aa9f047082612de0e7bbd119ff7fd9fd49d94d45ce2adfbbfb69a" => :yosemite
    sha256 "41f5cd09949d53b4d46dfab4a17d5f3d77f65978ebb5e04e3433f9386d7846b4" => :mavericks
    sha256 "3eff4144410ec431690c432060ec69c06e4a610f4e5e8a7159ca0d1fffd6d850" => :x86_64_linux
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      To complete the installation:
        . #{prefix}/g2-install.sh

      NOTE: This will install a new ~/.gitconfig, backing up any existing
      file first. For more information view:
        #{prefix}/README.md
    EOS
  end
end
