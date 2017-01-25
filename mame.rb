class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0182.tar.gz"
  version "0.182"
  sha256 "9ecb35afaa6006ccf027f4dfc91ac818d3a894e6e4c3732b6f3706ee40ed240b"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "cf8874630445d18a9144830d1264cf8bdcefc844650a0f0b95f2599817fb2e86" => :sierra
    sha256 "7b4888946f886f88afb2c3af87efbc3d15bd3807c0bc865d322563a7cb3ccff6" => :el_capitan
    sha256 "0b635b1d334826182cd8b26cb9fda82764dbb266a359e04064ac177bc30bf4ee" => :yosemite
  end

  option "with-tools", "Build MAME's tools"

  depends_on :macos => :yosemite
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "sdl2"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "portmidi"
  depends_on "portaudio"

  # Needs GCC 4.9 or newer
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.8").each do |n|
    fails_with :gcc => n
  end

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    args = [
      "USE_LIBSDL=1",
      "USE_SYSTEM_LIB_EXPAT=", # brewed version not picked up
      "USE_SYSTEM_LIB_ZLIB=1",
      "USE_SYSTEM_LIB_JPEG=1",
      "USE_SYSTEM_LIB_FLAC=1",
      "USE_SYSTEM_LIB_LUA=", # lua53 not available yet
      "USE_SYSTEM_LIB_PORTMIDI=1",
      "USE_SYSTEM_LIB_PORTAUDIO=1",
    ]
    args << "TOOLS=1" if build.with? "tools"

    system "make", *args

    bin.install "mame64" => "mame"
    cd "docs" do
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps plugins samples uismall.bdf]

    if build.with? "tools"
      bin.install %w[
        aueffectutil castool chdman floptool imgtool jedutil ldresample
        ldverify nltool nlwav pngcmp regrep romcmp src2html srcclean unidasm
      ]
      bin.install "split" => "rom-split"
      man1.install Dir["docs/man/*.1"]
    end
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"

    if build.with? "tools"
      # system "#{bin}/aueffectutil" # segmentation fault
      system "#{bin}/castool"
      assert_match "chdman info", shell_output("#{bin}/chdman help info", 1)
      system "#{bin}/floptool"
      system "#{bin}/imgtool", "listformats"
      system "#{bin}/jedutil", "-viewlist"
      assert_match "linear equation", shell_output("#{bin}/ldresample 2>&1", 1)
      assert_match "avifile.avi", shell_output("#{bin}/ldverify 2>&1", 1)
      system "#{bin}/nltool", "--help"
      system "#{bin}/nlwav", "--help"
      assert_match "image1", shell_output("#{bin}/pngcmp 2>&1", 10)
      assert_match "summary", shell_output("#{bin}/regrep 2>&1", 1)
      system "#{bin}/romcmp"
      system "#{bin}/rom-split"
      assert_match "template", shell_output("#{bin}/src2html 2>&1", 1)
      system "#{bin}/srcclean"
      assert_match "architecture", shell_output("#{bin}/unidasm", 1)
    end
  end
end
