class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-1-1.tar.gz"
  version "3.1.1"
  sha256 "c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02"
  license "GPL-2.0"
  revision 1
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "f741147b739d71d7bfb79e80ad89ad49f05a6922a36c6f663690c1a5f65cdcdb" => :big_sur
    sha256 "990abdbe32d92c4d6e7a17f1d5a2c1c4cd979f4daba30a8eba4a9e20a3e0d099" => :arm64_big_sur
    sha256 "770cdafc4dfdd0c216ca9308d5b5ae6b9b00be8d30b387dd2e86cbff82db5acd" => :catalina
    sha256 "6c44b3e574a786396b8099192e5154f1d751ee413ec265c99f8046fc5167876a" => :mojave
    sha256 "49d5dc2fc8c9a857bf08e6e6711fbaf48d8a0165c328cc400e904aa5a37080a4" => :high_sierra
    sha256 "c460add629080d7c4122a84d525ba9f75e6afe4c215ee160fc0840038c190dd7" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
