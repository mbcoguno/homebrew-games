class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0168.tar.gz"
  version "0.168"
  sha256 "3b6db52ddffed867ae171664e327f0b2bade64139d3450dc7166c4f90b6d94e8"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "648fe7fb0bd6b534462663f7978b154e6842727a9db859bc7c8db94cae788b10" => :el_capitan
    sha256 "0c8437846ca402ff96646a570ae6d0b37a49e6d394c1cc1464b1528a3d7e1dab" => :yosemite
    sha256 "91c8236acc885866fd93f189e6ead85be283174c195654c434e25c9e273f52ab" => :mavericks
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "sdl2"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "sqlite"
  depends_on "portmidi"

  def install
    inreplace "scripts/src/main.lua", /(targetsuffix) "\w+"/, '\1 ""'
    system "make", "PTR64=#{MacOS.prefer_64_bit? ? 1 : 0}", # for old Macs
                   "MACOSX_USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=", # brewed version not picked up
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_LUA=", # lua53 not available yet
                   "USE_SYSETM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1" # currently not used yet
    bin.install "mame"
    man6.install "src/osd/sdl/man/mame.6"
    doc.install Dir["docs/*"]
    pkgshare.install %w[artwork hash keymaps samples]
    (pkgshare/"shader").install Dir["src/osd/modules/opengl/shader/*.[vf]sh"]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "M.A.M.E. v#{version}"
    system "#{bin}/mame", "-validate"
  end
end
