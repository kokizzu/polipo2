PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/man
INFODIR = $(PREFIX)/info
LOCAL_ROOT = /usr/share/polipo2/www
DISK_CACHE_ROOT = /var/cache/polipo2

# To compile with Unix CC:

# CDEBUGFLAGS=-O

# To compile with GCC:

# CC = gcc
CDEBUGFLAGS = -Os -g -Wall -fno-strict-aliasing

# To compile on a pure POSIX system:

# CC = c89
# CC = c99
# CDEBUGFLAGS=-O

# To compile with icc 7, you need -restrict.  (Their bug.)

# CC=icc
# CDEBUGFLAGS = -O -restrict

# On System V (Solaris, HP/UX) you need the following:

# PLATFORM_DEFINES = -DSVR4

# On Solaris, you need the following:

# LDLIBS = -lsocket -lnsl -lresolv

# On mingw, you need

# EXE=.exe
# LDLIBS = -lws2_32

FILE_DEFINES = -DLOCAL_ROOT=\"$(LOCAL_ROOT)/\" \
               -DDISK_CACHE_ROOT=\"$(DISK_CACHE_ROOT)/\"

# You may optionally also add any of the following to DEFINES:
#
#  -DNO_DISK_CACHE to compile out the on-disk cache and local web server;
#  -DNO_IPv6 to avoid using the RFC 3493 API and stick to stock
#      Berkeley sockets;
#  -DHAVE_IPv6 to force the use of the RFC 3493 API on systems other
#      than GNU/Linux and BSD (let me know if it works);
#  -DNO_FANCY_RESOLVER to compile out the asynchronous name resolution
#      code;
#  -DNO_STANDARD_RESOLVER to compile out the code that falls back to
#      gethostbyname/getaddrinfo when DNS requests fail;
#  -DNO_TUNNEL to compile out the code that handles CONNECT requests;
#  -DNO_SOCKS to compile out the SOCKS gateway code.
#  -DNO_FORBIDDEN to compile out the all of the forbidden URL code
#  -DNO_REDIRECTOR to compile out the Squid-style redirector code
#  -DNO_SYSLOG to compile out logging to syslog

DEFINES = $(FILE_DEFINES) $(PLATFORM_DEFINES)

CFLAGS = $(MD5INCLUDES) $(CDEBUGFLAGS) $(DEFINES) $(EXTRA_DEFINES)

SRCS = util.c event.c io.c chunk.c atom.c object.c log.c diskcache.c main.c \
       config.c local.c http.c client.c server.c auth.c tunnel.c \
       http_parse.c parse_time.c dns.c forbidden.c \
       md5import.c md5.c ftsimport.c fts_compat.c socks.c mingw.c

HEADERS = atom.h auth.h chunk.h client.h config.h \
       dirent_compat.h diskcache.h dns.h event.h \
       forbidden.h fts_compat.h ftsimport.h http.h \
       http_parse.h io.h local.h log.h md5.h md5import.h \
       mingw.h object.h parse_time.h polipo2.h server.h \
       socks.h tunnel.h util.h

OBJS = util.o event.o io.o chunk.o atom.o object.o log.o diskcache.o main.o \
       config.o local.o http.o client.o server.o auth.o tunnel.o \
       http_parse.o parse_time.o dns.o forbidden.o \
       md5import.o ftsimport.o socks.o mingw.o

polipo2$(EXE): $(OBJS) $(HEADERS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o polipo2$(EXE) $(OBJS) $(MD5LIBS) $(LDLIBS)

ftsimport.o: ftsimport.c fts_compat.c

md5import.o: md5import.c md5.c

.PHONY: all install install.binary install.man

all: polipo2$(EXE) polipo2.info html/index.html localindex.html

install: install.binary install.man

install.binary: all
	mkdir -p $(TARGET)$(BINDIR)
	mkdir -p $(TARGET)$(LOCAL_ROOT)
	mkdir -p $(TARGET)$(LOCAL_ROOT)/doc
	rm -f $(TARGET)$(BINDIR)/polipo2
	cp -f polipo2 $(TARGET)$(BINDIR)/
	cp -f html/* $(TARGET)$(LOCAL_ROOT)/doc
	cp -f localindex.html $(TARGET)$(LOCAL_ROOT)/index.html

install.man: all
	mkdir -p $(TARGET)$(MANDIR)/man1
	mkdir -p $(TARGET)$(INFODIR)
	cp -f polipo2.man $(TARGET)$(MANDIR)/man1/polipo2.1
	cp polipo2.info $(TARGET)$(INFODIR)/
	install-info --info-dir=$(TARGET)$(INFODIR) polipo2.info


polipo2.info: polipo2.texi
	makeinfo polipo2.texi

html/index.html: polipo2.texi
	mkdir -p html
	makeinfo --html -o html polipo2.texi

polipo2.html: polipo2.texi
	makeinfo --html --no-split --no-headers -o polipo2.html polipo2.texi

polipo2.pdf: polipo2.texi
	texi2pdf polipo2.texi

polipo2.ps.gz: polipo2.ps
	gzip -c polipo2.ps > polipo2.ps.gz

polipo2.ps: polipo2.dvi
	dvips -Pwww -o polipo2.ps polipo2.dvi

polipo2.dvi: polipo2.texi
	texi2dvi polipo2.texi

polipo2.man.html: polipo2.man
	rman -f html polipo2.man > polipo2.man.html

TAGS: $(SRCS)
	etags $(SRCS)

.PHONY: clean

clean:
	-rm -f polipo2$(EXE) *.o *~ core TAGS gmon.out
	-rm -f polipo2.cp polipo2.fn polipo2.log polipo2.vr
	-rm -f polipo2.cps polipo2.info* polipo2.pg polipo2.toc polipo2.vrs
	-rm -f polipo2.aux polipo2.dvi polipo2.ky polipo2.ps polipo2.tp
	-rm -f polipo2.dvi polipo2.ps polipo2.ps.gz polipo2.pdf polipo2.html
	-rm -rf ./html/
	-rm -f polipo2.man.html
