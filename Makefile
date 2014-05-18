
.PHONY: lapis

SRC_DIR=$(CURDIR)/src
SECRET_DIR=$(CURDIR)/secret
WEB_DIR=$(CURDIR)/web

lapis: build
	lapis build

build: conf src

conf: config.moon secret/*.moon
	moonc *.moon
	cd $(SECRET_DIR) && moonc *.moon

src: src/*.moon
	cd $(SRC_DIR) && moonc -t $(WEB_DIR) *.moon

# Convenience task for increasing inotify watches (use sudo)
inotify:
	echo 12800 > /proc/sys/fs/inotify/max_user_watches

# If this fails, inotify max_user_watches may need to be increased
watch: build
	cd $(SRC_DIR) && moonc -t $(WEB_DIR) -w ./

lint:
	moonc -l $$(git ls-files | grep '\.moon$$' | grep -v config.moon)

test:
	busted

test_db:
	echo "testing"

#schema:
#	lapis exec 'require"schema".make_schema()'

routes:
	lapis exec 'require "cmd.routes"'

clean::
	rm --preserve-root -f nginx.conf.compiled
	rm --preserve-root -f *.lua
	rm --preserve-root -f secret/*.lua
	rm --preserve-root -f web/*.lua
	rm --preserve-root -f web/*/*.lua

