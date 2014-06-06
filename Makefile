
MOONC ?= $(HOME)/.luarocks/bin/moonc
RM = rm --preserve-root -f
RMDIR = $(RM) -r

SOURCEDIR = ./src
BUILDDIR = ./web

SOURCES = $(shell find $(SOURCEDIR) -type f -name '*.moon')
OBJECTS = $(patsubst $(SOURCEDIR)/%.moon,$(BUILDDIR)/%.lua,$(SOURCES))

all: $(OBJECTS)

$(OBJECTS): $(BUILDDIR)/%.lua : $(SOURCEDIR)/%.moon
	$(MOONC) -o $@ $<

# Convenience task for increasing inotify watches (use sudo)
inotify:
	echo 12800 > /proc/sys/fs/inotify/max_user_watches

lapis:
	lapis build

lint:
	moonc -l $$(git ls-files | grep '\.moon$$' | grep -v config.moon)

test: $(OBJECTS)
	busted

db:: build dbtest schema migrate

dbtest::
	lapis exec 'require"lapis.db".query"select 1"'

schema:: conf dbtest
	lapis exec 'require"db.schema".create_schema()'

migrate:: conf dbtest
	lapis exec 'require"lapis.db.migrations".create_migrations_table()'
	lapis exec 'require"lapis.db.migrations".run_migrations(require"db.migrations")'

routes: all lapis
	lapis exec 'require "cmd.routes"'

clean::
	$(RM) *.lua
	$(RM) secret/*.lua
	$(RMDIR) $(BUILDDIR)

clean_lapis::
	$(RM) nginx.conf.compiled
	$(RMDIR) fastcgi_temp
	$(RMDIR) uwsgi_temp
	$(RMDIR) scgi_temp
	$(RMDIR) client_body_temp
	$(RMDIR) proxy_temp
	$(RMDIR) logs

