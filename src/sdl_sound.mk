# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SDL_sound
PKG             := sdl_sound
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 1984bc20b2c756dc71107a5a0a8cebfe07e58cb1
$(PKG)_SUBDIR   := SDL_sound-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_sound-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://icculus.org/SDL_sound/
$(PKG)_URL      := http://icculus.org/SDL_sound/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl libmikmod ogg vorbis flac speex

define $(PKG)_UPDATE
    wget -q -O- 'http://hg.icculus.org/icculus/SDL_sound/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --enable-voc \
        --enable-wav \
        --enable-raw \
        --enable-aiff \
        --enable-au \
        --enable-shn \
        --enable-midi \
        --disable-smpeg \
        --enable-mpglib \
        --enable-mikmod \
        --disable-modplug \
        --enable-ogg \
        --enable-flac \
        --enable-speex \
        --disable-physfs \
        --disable-altcvt \
        LIBS="`'$(TARGET)-pkg-config' vorbisfile flac speex --libs` `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --libs`" \
        CFLAGS='-fno-inline'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_sound.exe' \
        -lSDL_sound \
        `'$(TARGET)-pkg-config' sdl vorbisfile flac speex --cflags --libs` \
        `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --cflags --libs`
endef