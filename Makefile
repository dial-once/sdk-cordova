.PHONY: deps test sample build clean

ANDROID_API_KEY=OWNkY2RkODZiNDA1MjY5YjE2ZTc3ZDMzODEwNWZmNDM6OmIwMjYwMjllYWVhYjc5MzQxYjdkOWZjNDMyYzdlMTc3NDNjNTdjZTE=
BUILD_DIR=$(PWD)/build
TESTAPP_PATH=$(BUILD_DIR)/sample
TESTPLUGIN_PATH=$(BUILD_DIR)/plugin
ANDROID_PLATFORM_VERSION=
TESTAPP_PLUGINS=cordova-plugin-test-framework			\
	cordova-android-support-gradle-release				\
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
	cordova-plugin-file-opener2

TEST_CORDOVA_VERSIONS=8.0.0 7.1.0 6.5.0
CORDOVA_LOCAL=PATH=$(shell npm bin):$(PATH) cordova

# More info about cordova <-> cordova-android <-> android-api relations here
# https://cordova.apache.org/docs/en/latest/guide/platforms/android/

deps:
	npm install -g cordova
	npm link cordova
	npm i

# plugin target need to avoid ENAMETOOLONG during plugin copy
$(TESTPLUGIN_PATH):
	mkdir -p $(TESTPLUGIN_PATH)
	cp -r src www package.json plugin.xml $(TESTPLUGIN_PATH)/

$(TESTAPP_PATH): $(TESTPLUGIN_PATH)
	mkdir -p $(TESTAPP_PATH)
	$(CORDOVA_LOCAL) create $(TESTAPP_PATH) com.dialonce.sample DialCordova

	cp -r sample/* $(BUILD_DIR)/sample/www/
	
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) platform add android@$(ANDROID_PLATFORM_VERSION)

	# compatibility test
	cd $(TESTAPP_PATH); $(foreach plugin, $(TESTAPP_PLUGINS), $(CORDOVA_LOCAL) plugin add $(plugin);)

sample-prod: 
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) plugin add cordova-plugin-dialonce@2.6.14 --variable ANDROID_API_KEY=$(ANDROID_API_KEY)

sample: $(TESTAPP_PATH)
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) -d plugin add $(TESTPLUGIN_PATH) --variable ANDROID_API_KEY=$(ANDROID_API_KEY)

build-prod: sample-prod
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) build android

build: sample
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) build android
	mkdir -p $(PWD)/build/sdk
	zip build/sdk/cordova-plugin-dialonce-$(shell date "+%d-%m-%Y").zip -r src www package.json plugin.xml README.md

testVersions:
	$(foreach version,$(TEST_CORDOVA_VERSIONS), npm install cordova@$(version) && make build || exit 1; rm -rf node_modules;)

test:
	mkdir -p $(BUILD_DIR)/test
	node node_modules/cordova-paramedic/main.js --platform android --target $(shell adb get-serialno) --externalServerUrl http://10.0.3.2 --outputDir $(BUILD_DIR)/test --plugin ./ --verbose
	
install:
	cd $(TESTAPP_PATH); $(CORDOVA_LOCAL) run android

publish:
	npm login
	npm publish .

clean:
	rm -rf build node_modules
