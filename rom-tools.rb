class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0167.tar.gz"
  version "0.167"
  sha256 "fbb7fb8c98c2a26fed44441732d5c64c7c9c7417288e6b71a5cd0cea433e5064"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "30d4a0d4546296f76242c0040e0d20e7cc85a1e2dbb6672d1b037841478697f0" => :el_capitan
    sha256 "4c37f73cf7a36e7bb9491416a2e0b8b131bee53a4e3d0009a379adfea0b842a2" => :yosemite
    sha256 "3c7f2439f6ee7c3c13251c5da599b79e24d3c823159242d8405308c238a48f38" => :mavericks
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "sdl2"
  depends_on "flac"
  depends_on "sqlite"
  depends_on "portmidi"

  def install
    inreplace "scripts/src/main.lua", /(targetsuffix) "\w+"/, '\1 ""'
    system "make", "TARGET=ldplayer", "TOOLS=1",
                   "PTR64=#{MacOS.prefer_64_bit? ? 1 : 0}", # for old Macs
                   "MACOSX_USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1"
    bin.install %W[
      aueffectutil castool chdman floptool imgtool jedutil ldplayer ldresample
      ldverify nltool nlwav pngcmp regrep romcmp src2html srcclean testkeys unidasm
    ]
    bin.install "split" => "rom-split"
    man1.install Dir["src/osd/sdl/man/*.1"]
  end

  # Needs more comprehensive tests
  test do
    # system "#{bin}/aueffectutil" # segmentation fault
    system "#{bin}/castool"
    # system "#{bin}/chdman"
    system "#{bin}/floptool"
    system "#{bin}/imgtool", "listformats"
    system "#{bin}/jedutil", "-viewlist"
    system "#{bin}/ldplayer", "-help"
    # system "#{bin}/ldresample"
    # system "#{bin}/ldverify"
    # system "#{bin}/nltool", "--help" # segmentation fault
    # system "#{bin}/nlwav", "--help" # segmentation fault
    # system "#{bin}/pngcmp"
    # system "#{bin}/regrep"
    system "#{bin}/romcmp"
    system "#{bin}/rom-split"
    # system "#{bin}/src2html"
    # system "#{bin}/srcclean"
    # system "#{bin}/testkeys"
    # system "#{bin}/unidasm"
  end
end
