
.PHONY: all

MOONC ?= moonc
RM = rm --preserve-root -fv
RMDIR = $(RM) -r

SOURCEDIR = ./src
BUILDDIR = ./web/lua
SPECDIR = ./spec

APP_SOURCES = $(shell find $(SOURCEDIR) -type f -name '*.moon' -not -path "$(SPECDIR)/*")
APP_OBJECTS = $(patsubst $(SOURCEDIR)/%.moon,$(BUILDDIR)/%.lua,$(APP_SOURCES))

CONF_SOURCES = $(shell find -name "*.moon" -not -path "./web/*" -and -not -path "./src/*" -and -not -path './spec/*')
CONF_OBJECTS = $(patsubst ./%.moon,./%.lua,$(CONF_SOURCES))

LAPIS_SOURCES = nginx.conf
LAPIS_OBJECTS = nginx.conf.compiled

all: compile lint lapis

ci: all test

compile: $(APP_OBJECTS) $(CONF_OBJECTS)

$(APP_OBJECTS): $(BUILDDIR)/%.lua : $(SOURCEDIR)/%.moon
	@$(MOONC) -o $@ $<

$(CONF_OBJECTS): ./%.lua : ./%.moon
	@$(MOONC) $<

# Convenience task for increasing inotify watches (use sudo)
inotify:
	echo 12800 > /proc/sys/fs/inotify/max_user_watches

$(LAPIS_OBJECTS): ./%.conf.compiled : ./%.conf
	@lapis build

lapis: $(LAPIS_OBJECTS)

lint:
	@moonc -l $(APP_SOURCES)

test: $(APP_OBJECTS)
	@busted

db:: all dbtest schema migrate

dbtest::
	@lapis exec 'require"lapis.db".query"select 1"'

schema:: $(CONF_OBJECTS) dbtest
	@lapis exec 'require"db.schema".create_schema()'

migrate:: $(CONF_OBJECTS) dbtest
	@lapis exec 'require"lapis.db.migrations".create_migrations_table()'
	@lapis exec 'require"lapis.db.migrations".run_migrations(require"db.migrations")'

routes: all lapis
	@lapis exec 'require "cmd.routes"'

run: all lapis
	@lapis server

clean:: clean_src clean_lapis

clean_src::
	@$(RM) $(CONF_OBJECTS) $(APP_OBJECTS)
	@$(RMDIR) $(BUILDDIR)

clean_lapis::
	@$(RM) $(LAPIS_OBJECTS)
	@$(RMDIR) fastcgi_temp uwsgi_temp scgi_temp client_body_temp proxy_temp logs

clean_schema::
	@lapis exec 'require"db.schema".destroy_schema()'

