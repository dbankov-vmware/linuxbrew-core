class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision OS.mac? ? 6 : 7
  head "https://github.com/FFmpeg/FFmpeg.git"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.xz"
    sha256 "ad009240d46e307b4e03a213a0f49c11b650e445b1f8be0dda2a9212b34d2ffb"

    # https://trac.ffmpeg.org/ticket/8760
    # Remove in next release
    patch do
      url "https://github.com/FFmpeg/FFmpeg/commit/7c59e1b0f285cd7c7b35fcd71f49c5fd52cf9315.patch?full_index=1"
      sha256 "1cbe1b68d70eadd49080a6e512a35f3e230de26b6e1b1c859d9119906417737f"
    end
  end

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "c6342f638203e0d6bda7ce92add949a7a2db0a4fb2ac205637d92d713298ecad" => :big_sur
    sha256 "f3d75997805fa7139d5dde99b1dd58d5877958b2dc76997f9e8ad0d84e8edd89" => :arm64_big_sur
    sha256 "9af13c4b632cf0f092fe6178e256deb1a702f7465b0211c3c5994ae19467a59c" => :catalina
    sha256 "3c3765174346a8da8043e376901deb15c22cc2c3ebf3554c87591d4ab6063cd1" => :mojave
    sha256 "ca00c9d8ab726467e4ba21718bf10b0b995c5e201e6a697ee98914f8d3ff6bd6" => :x86_64_linux
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libsoxr"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "openjpeg"
  depends_on "opus"
  depends_on "rav1e"
  depends_on "rtmpdump"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "speex"
  depends_on "srt"
  depends_on "tesseract"
  depends_on "theora"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"
  depends_on "zeromq"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  depends_on "libxv" unless OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --enable-avresample
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libaom
      --enable-libbluray
      --enable-libdav1d
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
      --enable-libtesseract
      --enable-libtheora
      --enable-libvidstab
      --enable-libvorbis
      --enable-libvpx
      --enable-libwebp
      --enable-libx264
      --enable-libx265
      --enable-libxml2
      --enable-libxvid
      --enable-lzma
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-librtmp
      --enable-libspeex
      --enable-libsoxr
      --enable-libzmq
      --disable-libjack
      --disable-indev=jack
    ]

    args << "--enable-videotoolbox" if OS.mac?

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
