var exec = require('cordova/exec');

var dialonce = {
    /**
     * Request permissions to ensure the SDK to work properly
     */
    requestPermissions: function() {
        exec(null, null, "DialOnce", "requestPermissions", []);
    }
};

module.exports = dialonce;
