class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "http://eighttails.up.seesaa.net/bin/PC6001VX_2.30.0_src.tar.gz"
  sha256 "51347ba79b05c66fe029cfc430ba2a4661b61d25ec3b03bc405b52a2fac97021"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "83624d963ab2211101c4c2f862025974b921081e1ec5b0ba5d917f32f657d9fa" => :el_capitan
    sha256 "faf4f70dfffa85a25e3c11c9419c82b03ad67a779dc19a043864dbfbf00d3255" => :yosemite
    sha256 "3642c11f7fcca354f8e3ab07f0d54c599b8ec79afd04bea822986c3c5b158628" => :mavericks
  end

  depends_on "qt@5.7"
  depends_on "sdl2"
  depends_on "ffmpeg"

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["sdl2"].opt_include}"
    ENV.append_to_cflags "-I#{Formula["ffmpeg"].opt_include}"
    # Turn off errors on C++11 build which used for properly linking standard lib
    ENV.append_to_cflags "-Wno-reserved-user-defined-literal"
    # Use libc++ explicitly, otherwise build fails
    ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang
    system "qmake", "PREFIX=#{prefix}", "QMAKE_CXXFLAGS=#{ENV.cxxflags}", "CONFIG+=c++11"
    system "make"
    prefix.install "PC6001VX.app"
    bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
  end
end
