
.PHONY: all

MOONC ?= $(HOME)/.luarocks/bin/moonc
RM = rm --preserve-root -f
RMDIR = $(RM) -r

SOURCEDIR = ./src
BUILDDIR = ./web

APP_SOURCES = $(shell find $(SOURCEDIR) -type f -name '*.moon')
APP_OBJECTS = $(patsubst $(SOURCEDIR)/%.moon,$(BUILDDIR)/%.lua,$(APP_SOURCES))

CONF_SOURCES = $(shell find -name "*.moon" -not -path "./web/*" -and -not -path "./src/*")
CONF_OBJECTS = $(patsubst ./%.moon,./%.lua,$(CONF_SOURCES))

all: compile lint lapis

compile: $(APP_OBJECTS) $(CONF_OBJECTS)

$(APP_OBJECTS): $(BUILDDIR)/%.lua : $(SOURCEDIR)/%.moon
	$(MOONC) -o $@ $<

$(CONF_OBJECTS): ./%.lua : ./%.moon
	$(MOONC) $<

# Convenience task for increasing inotify watches (use sudo)
inotify:
	echo 12800 > /proc/sys/fs/inotify/max_user_watches

lapis:
	lapis build

lint:
	moonc -l $$(git ls-files | grep '\.moon$$' | grep -v config.moon)

test: $(APP_OBJECTS)
	busted

db:: all dbtest schema migrate

dbtest::
	lapis exec 'require"lapis.db".query"select 1"'

schema:: $(CONF_OBJECTS) dbtest
	lapis exec 'require"db.schema".create_schema()'

migrate:: $(CONF_OBJECTS) dbtest
	lapis exec 'require"lapis.db.migrations".create_migrations_table()'
	lapis exec 'require"lapis.db.migrations".run_migrations(require"db.migrations")'

routes: all lapis
	lapis exec 'require "cmd.routes"'

clean::
	$(RM) $(CONF_OBJECTS) $(APP_OBJECTS)

clean_lapis::
	$(RM) nginx.conf.compiled
	$(RMDIR) fastcgi_temp
	$(RMDIR) uwsgi_temp
	$(RMDIR) scgi_temp
	$(RMDIR) client_body_temp
	$(RMDIR) proxy_temp
	$(RMDIR) logs

