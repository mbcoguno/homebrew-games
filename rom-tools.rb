class RomTools < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0162.tar.gz"
  sha256 "97b5154177cf7fa862f72be0a5a1241d4560a44bc00c2ac1785f0ae706deb899"
  version "0.162"

  head "https://github.com/mamedev/mame.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-games"
    cellar :any
    sha256 "375cb5259041202c2396e02ce4755fdbd23c105652ed137e8cc6a083c1957c5d" => :yosemite
    sha256 "9e155683935968140c00dd20e53e9d25fd2c697695f625302c73ef5b145ad267" => :mavericks
    sha256 "d3d88cc2f621dffcc081ef549e5bb06f7eb0f98ce8de38dadc63efd188ee7100" => :mountain_lion
  end

  depends_on "sdl2"

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ldplayer", "TOOLS=1"

    bin.install %W[
      castool chdman floptool imgtool jedutil ldresample ldverify nltool pngcmp
      regrep romcmp src2html srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
    if MacOS.prefer_64_bit?
      bin.install "ldplayer64" => "ldplayer"
    else
      bin.install "ldplayer"
    end
    man1.install Dir["src/osd/sdl/man/*.1"]
  end
end
