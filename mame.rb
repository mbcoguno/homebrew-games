require "formula"

class Mame < Formula
  homepage "http://mamedev.org/"
  url "svn://dspnet.fr/mame/trunk", :revision => "31397"
  version "0.154"

  head "svn://dspnet.fr/mame/trunk"

  depends_on "sdl"

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}",
                   "TARGET=mame", "SUBTARGET=mame"

    if MacOS.prefer_64_bit?
      bin.install "mame64" => "mame"
    else
      bin.install "mame"
    end
  end
end
