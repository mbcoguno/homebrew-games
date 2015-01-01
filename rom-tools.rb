class RomTools < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0157.tar.gz"
  sha1 "cac1ccb4194715be63dd4d4754a575b9e1c11ea3"
  version "0.157"

  head "https://github.com/mamedev/mame.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/games"
    cellar :any
    sha1 "731e38a5246a2c87fe73748852c7f66012d17bb5" => :yosemite
    sha1 "4e1c9496362e207c32f2fdd4b04201a0c2480b6c" => :mavericks
    sha1 "12c9e0f1ae6ce2ecb1099664f7b98ba6a5bfc18a" => :mountain_lion
  end

  depends_on "sdl2"

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")
    ENV["LTO"] = "1" if ENV.compiler == :clang or ENV.compiler =~ /^gcc-(4\.[6-9])$/

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "tools"
    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ldplayer"

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
