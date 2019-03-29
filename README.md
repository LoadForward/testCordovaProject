# testCordovaProject
Cordova组件化构建webAPP
# cordova环境安装
### 1.安装node.js
  &nbsp;&nbsp;请自行安装
### 2.安装cordova<br>
  &nbsp;&nbsp;npm install -g cordova<br>
### 3.创建项目
  &nbsp;&nbsp;cordova create testCordovaProject com.catchzeng.testCordova testCordova<br>
  #### &nbsp;&nbsp;参数含义：
  &nbsp;&nbsp;testCordovaProject: 项目文件夹名称<br>
  &nbsp;&nbsp;com.catchzeng.testCordova: 项目的bundleID<br>
  &nbsp;&nbsp;testCordova:项目名称<br>
### 4.添加平台
  &nbsp;&nbsp;cd testCordovaProject/<br>
  &nbsp;&nbsp;sudo cordova platform add ios<br>
  ##### &nbsp;&nbsp;添加成功后可在项目的platforms文件夹中看到ios文件夹,进入后就可以看到ios工程了。
