class RomTools < Formula
  desc "Tools for Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0166.tar.gz"
  version "0.166"
  sha256 "702a2019a05afd7f050db6b38c3aaee4cc46ec2214cecaed3420889a685637f4"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "8317167d2d01a0ad8a0d287baa65e4f205b906ebd26d35caeaaa4605198324f0" => :yosemite
    sha256 "b4d4e728d3e3f7bed9c9dfa70b77de28df02649282f2bf79118281fa44e5ab3b" => :mavericks
    sha256 "c6dc8b0e8bf4c028ba85f62bf4d2d9140cea3d73ee46cc2547a9cbcffc3677c3" => :mountain_lion
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
