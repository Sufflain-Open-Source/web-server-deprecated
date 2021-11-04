BUILD_DIR=build
COMPILED_DIR=compiled

all: sflw

sflw: $(BUILD_DIR) web/$(COMPILED_DIR) web/img
	dart compile exe -o $(BUILD_DIR)/$@.exe bin/web_server.dart

$(BUILD_DIR):
	mkdir $@

web/img:
	mkdir $@
	cp web/app/img/* $@/

web/$(COMPILED_DIR): web/app/build
	mkdir web/$(COMPILED_DIR)
	cp -r ./web/app/build/* ./web/$(COMPILED_DIR)

web/app/build:
	web/app/build/build.sh

clean:
	if [ -d "$(BUILD_DIR)" ]; then\
	 rm -r $(BUILD_DIR) ; \
	fi

	if [ -d "web/$(COMPILED_DIR)" ]; then\
	 rm -r web/$(COMPILED_DIR) ; \
	fi

	if [ -d "web/img" ]; then\
	 rm -r web/img ; \
	fi