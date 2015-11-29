class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0168.tar.gz"
  version "0.168"
  sha256 "3b6db52ddffed867ae171664e327f0b2bade64139d3450dc7166c4f90b6d94e8"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "cd5aad6342f34850d2bb39d0b0f14561d0d6464b6d58b58ec4f7b7d8fa037f6d" => :el_capitan
    sha256 "fa25f757ecb9eb86b0c67552d5359224076d63ef873fdb9e9df4cdaff2ceef01" => :yosemite
    sha256 "bfc1eda16ba5c3e5d78e84bb92cbbb28e045726bbadb29610fdd2dbd6e9fff28" => :mavericks
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
