class RomTools < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0161.tar.gz"
  sha256 "f7db934676e90d0d7f2b678ccf32e580417c754dd33117ec683560956c2130b9"
  version "0.161"

  head "https://github.com/mamedev/mame.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-games"
    cellar :any
    sha256 "be5b2390e63a6f86bb7021afc119d74f40c0a3c051399d0beccf748216bc0550" => :yosemite
    sha256 "5ac067f43b03e6abcfcb248e081f9b24a8bb7516a7c08a1bdcd5c06604c88384" => :mavericks
    sha256 "d52fb8f6b058044b7503a04002888d36b9438e6a89245aa4335fe443f497e867" => :mountain_lion
  end

  depends_on "sdl2"

  # Use OpenGL extensions for non-framework SDL 2 environment.
  # Upstream: <https://github.com/mamedev/mame/pull/170>
  patch do
    url "https://github.com/mbcoguno/mame/commit/05f71a27f9.diff"
    sha256 "d7c82d97cc9367226b44bcd174b98ce56f96b034f12a0af7cae1da76065a947c"
  end

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ldplayer", "TOOLS=1"

    bin.install %W[
      chdman jedutil ldresample ldverify nltool pngcmp regrep romcmp src2html
      srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
    if MacOS.prefer_64_bit?
      bin.install "ldplayer64" => "ldplayer"
    else
      bin.install "ldplayer"
    end
    %W[chdman jedutil ldplayer ldresample ldverify romcmp testkeys].each do |manfile|
      man1.install "src/osd/sdl/man/#{manfile}.1"
    end
  end
end
