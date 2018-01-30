var exec = require('cordova/exec');

var dialonce = {
	isCallInterceptionEnabled: true,
    /**
     * Request permissions to ensure the SDK to work properly
     */
    requestPermissions: function() {
        exec(null, null, "DialOnce", "requestPermissions", []);
    },

    setEnableCallInterception: function(enabled) {
    	exec(null, null, "DialOnce", "setEnableCallInterception", [enabled]);
    	this.isCallInterceptionEnabled = enabled;
    }
};

module.exports = dialonce;
