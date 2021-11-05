BUILD_DIR=build
COMPILED_DIR=compiled

$(BUILD_DIR)/sflw.exe: $(BUILD_DIR)/sflw
	mv $(BUILD_DIR)/sflw $(BUILD_DIR)/sflw.exe

$(BUILD_DIR)/sflw: $(BUILD_DIR) web/$(COMPILED_DIR) web/img
	dart compile exe -o $@ bin/web_server.dart

$(BUILD_DIR):
	mkdir $@

web/img:
	mkdir $@
	cp web/app/img/* $@/
	cp web/app/build/img/sufflain-colored-outline.svg web/img/

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