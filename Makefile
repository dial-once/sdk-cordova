.PHONY: deps test sample build clean

ANDROID_API_KEY=OWNkY2RkODZiNDA1MjY5YjE2ZTc3ZDMzODEwNWZmNDM6OmIwMjYwMjllYWVhYjc5MzQxYjdkOWZjNDMyYzdlMTc3NDNjNTdjZTE=
BUILD_DIR=$(PWD)/build
TESTAPP_PATH=$(BUILD_DIR)/sample
TESTPLUGIN_PATH=$(BUILD_DIR)/plugin
ANDROID_PLATFORM_VERSION=6.3.0
TESTAPP_PLUGINS= cordova-android-support-gradle-release	\
	cordova-plugin-splashscreen							\
	cordova-plugin-device								\
	cordova-plugin-geolocation							\
	cordova-plugin-inappbrowser							\
	cordova-plugin-network-information					\
	cordova-plugin-splashscreen							\
	cordova-plugin-statusbar							\
	cordova-plugin-whitelist							\
	cordova-plugin-file									\
	ionic-plugin-keyboard								\
	cordova-plugin-android-permissions					\
	cordova-plugin-apprate								\
	cordova-plugin-file-opener2							\

TESTAPP_PLUGINS1=cordova-plugin-crosswalk-webview@2.2.0 --variable XWALK_VERSION=20 --variable XWALK_COMMANDLINE=--disable-pull-to-refresh-effect --variable XWALK_MODE=embedded

TEST_CORDOVA_VERSIONS=6.5.0 7.1.0
CORDOVA_LOCAL=PATH=$(shell npm bin):$(PATH) cordova

# More info about cordova <-> cordova-android <-> android-api relations here
# https://cordova.apache.org/docs/en/latest/guide/platforms/android/

deps:
	npm install -g cordova
	npm link cordova
	yes | android update sdk --no-ui --all --filter tools

# plugin target need to avoid ENAMETOOLONG during plugin copy
$(TESTPLUGIN_PATH):
	mkdir -p $(TESTPLUGIN_PATH)
	cp -r src www package.json plugin.xml $(TESTPLUGIN_PATH)/

$(TESTAPP_PATH): $(TESTPLUGIN_PATH)
	mkdir -p $(TESTAPP_PATH)
	$(CORDOVA_LOCAL) create $(TESTAPP_PATH) com.dialonce.sample DialCordova

	cp sample/index.html $(BUILD_DIR)/sample/www/index.html
	cp sample/index.js $(BUILD_DIR)/sample/www/js/index.js

	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) platform add android@$(ANDROID_PLATFORM_VERSION)

ifdef PROD_SDK
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) plugin add cordova-plugin-dialonce@2.6.13 --variable ANDROID_API_KEY=$(ANDROID_API_KEY)
else
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) -d plugin add $(TESTPLUGIN_PATH) --variable ANDROID_API_KEY=$(ANDROID_API_KEY)
endif

	# compatibility test
	cd $(TESTAPP_PATH); $(foreach plugin, $(TESTAPP_PLUGINS), $(CORDOVA_LOCAL) plugin add $(plugin);)
	# cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) plugin add $(TESTAPP_PLUGINS1)

sample: $(TESTAPP_PATH)

build: sample
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) build android
	mkdir -p $(PWD)/build/sdk
	zip build/sdk/cordova-plugin-dialonce-$(shell date "+%d-%m-%Y").zip -r src www package.json plugin.xml README.md

test:
	$(foreach version,$(TEST_CORDOVA_VERSIONS), npm install cordova@$(version) && make build || exit 1; rm -rf node_modules;)

install:
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) run android

publish:
	npm login
	npm publish .

clean:
	rm -rf build node_modules
