
/********测试插件js********/
function testPlugin() {
    /****
     * testSuccess：调用成功处理函数
     * testFailed：调用失败处理函数
     * ocTestPlugin：oc插件名称
     * testWithTitle：oc插件暴露的方法名
     ****/
    cordova.exec(testSuccess,testFailed,"ocTestPlugin","testWithTitle",["我是JS传的参数！"]);
}
function testSuccess(msg) {
    alert(msg);
}
function testFailed(msg) {
    alert('failed: ' + msg);
}

/********调用系统多媒体库插件js********/
function cameraPlugin() {
    cordova.exec(getPhotoSuccess, getPhotoFailure, "ocCameraPlugin", "useCameraWithTitle", ["调用系统多媒体库"]);
}

function getPhotoSuccess(msg) {
    var largeImage = document.getElementById('largeImage');
    largeImage.style.display = 'block';
    largeImage.src = msg;
}

function getPhotoFailure(msg) {
    alert(msg);
}

/********调用系统定位插件js********/
function locationPlugin() {
    cordova.exec(locationUpdated, function(){}, "ocLocationPlugin", "showCurrentLocation", ["调用系统定位"]);
}

function locationUpdated(msg) {
    alert(msg);
    var location_p = document.getElementById('location-id');
    location_p.innerHTML = msg;
}
