lib_LTLIBRARIES = libfoo.la libbar.la
libfoo_la_SOURCES = libfoo.c
libbar_la_SOURCES = libbar.c
libbar_la_LIBADD = $(top_builddir)/libfoo.la
noinst_PROGRAMS = exe
exe_LDADD = $(top_builddir)/libbar.la
