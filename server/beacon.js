var Bleacon = require('bleacon');
var uuid = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
var major = 0;
var minor = 0;
var measuredPower = -59;
Bleacon.startAdvertising(uuid, major, minor, measuredPower);
