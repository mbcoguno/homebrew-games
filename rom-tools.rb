require 'formula'

class RomTools < Formula
  homepage 'http://mamedev.org/'
  url 'svn://dspnet.fr/mame/trunk', :revision => '21963'
  version '0.148u2'

  head 'svn://dspnet.fr/mame/trunk'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = "-I#{MacOS::X11.include}"
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system 'make', "CC=#{ENV.cc}", "LD=#{ENV.cxx}", 'tools'
    system 'make', "CC=#{ENV.cc}", "LD=#{ENV.cxx}", 'TARGET=ldplayer'

    bin.install %W[
      chdman jedutil ldresample ldverify regrep romcmp src2html srcclean
      testkeys unidasm
    ]
    bin.install 'split' => 'rom-split'
    if MacOS.prefer_64_bit?
      bin.install 'ldplayer64' => 'ldplayer'
    else
      bin.install 'ldplayer'
    end
  end
end
