require "formula"

class RomTools < Formula
  homepage "http://mamedev.org/"
  url "svn://dspnet.fr/mame/trunk", :revision => "29406"
  version "0.153"

  head "svn://dspnet.fr/mame/trunk"

  depends_on :x11
  depends_on "sdl"

  # Keep bus part in separate library can make visual studio builds possible,
  # but it cause ldplayer build failed, since it doesn't build bus library.
  patch :DATA

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["INCPATH"] = "-I#{MacOS::X11.include}"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")

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
  end
end

__END__
diff --git a/makefile b/makefile
index 47db5dc..8e22b9d 100644
--- a/makefile
+++ b/makefile
@@ -678,7 +678,6 @@

 LIBEMU = $(OBJ)/libemu.a
 LIBOPTIONAL = $(OBJ)/$(TARGET)/$(SUBTARGET)/liboptional.a
-LIBBUS = $(OBJ)/$(TARGET)/$(SUBTARGET)/libbus.a
 LIBDASM = $(OBJ)/$(TARGET)/$(SUBTARGET)/libdasm.a
 LIBUTIL = $(OBJ)/libutil.a
 LIBOCORE = $(OBJ)/libocore.a
@@ -871,7 +870,7 @@

 ifndef EXECUTABLE_DEFINED

-$(EMULATOR): $(EMUINFOOBJ) $(DRIVLISTOBJ) $(DRVLIBS) $(LIBOSD) $(LIBBUS) $(LIBOPTIONAL) $(LIBEMU) $(LIBDASM) $(LIBUTIL) $(EXPAT) $(SOFTFLOAT) $(JPEG_LIB) $(FLAC_LIB) $(7Z_LIB) $(FORMATS_LIB) $(LUA_LIB) $(WEB_LIB) $(ZLIB) $(LIBOCORE) $(MIDI_LIB) $(RESFILE)
+$(EMULATOR): $(EMUINFOOBJ) $(DRIVLISTOBJ) $(DRVLIBS) $(LIBOSD) $(LIBOPTIONAL) $(LIBEMU) $(LIBDASM) $(LIBUTIL) $(EXPAT) $(SOFTFLOAT) $(JPEG_LIB) $(FLAC_LIB) $(7Z_LIB) $(FORMATS_LIB) $(LUA_LIB) $(WEB_LIB) $(ZLIB) $(LIBOCORE) $(MIDI_LIB) $(RESFILE)
 	$(CC) $(CDEFS) $(CFLAGS) -c $(SRC)/version.c -o $(VERSIONOBJ)
 	@echo Linking $@...
 	$(LD) $(LDFLAGS) $(LDFLAGSEMULATOR) $(VERSIONOBJ) $^ $(LIBS) -o $@
