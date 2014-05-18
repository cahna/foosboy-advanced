
.PHONY: build

SRC_DIR=$(CURDIR)/src
WEB_DIR=$(CURDIR)/web

RM ?= rm --preserve-root -f -v
RMDIR ?= $(RM) -r

build:: conf lapis
	cd $(SRC_DIR) && moonc -t $(WEB_DIR) *.moon */*.moon

conf::
	moonc *.moon secret/*.moon db/*.moon

lapis::
	lapis build

# Convenience task for increasing inotify watches (use sudo)
inotify:
	echo 12800 > /proc/sys/fs/inotify/max_user_watches

# If this fails, inotify max_user_watches may need to be increased
watch:: build
	cd $(SRC_DIR) && moonc -t $(WEB_DIR) -w ./

lint:
	moonc -l $$(git ls-files | grep '\.moon$$' | grep -v config.moon)

test: build
	busted

db:: build dbtest schema migrate

dbtest::
	lapis exec 'require"lapis.db".query"select 1"'

schema:: conf dbtest
	lapis exec 'require"db.schema".create_schema()'

migrate:: conf dbtest
	lapis exec 'require"lapis.db.migrations".create_migrations_table()'
	lapis exec 'require"lapis.db.migrations".run_migrations(require"db.migrations")'

routes:
	lapis exec 'require "cmd.routes"'

clean::
	$(RM) nginx.conf.compiled
	$(RM) *.lua
	$(RM) secret/*.lua
	$(RM) web/*.lua
	$(RM) web/*/*.lua
	$(RMDIR) fastcgi_temp
	$(RMDIR) uwsgi_temp
	$(RMDIR) scgi_temp
	$(RMDIR) client_body_temp
	$(RMDIR) proxy_temp
	$(RMDIR) logs

