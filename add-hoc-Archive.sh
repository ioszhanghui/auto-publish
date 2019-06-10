packaging(){

#ProjectName Scheme Configuration Workspace不能留空格
#***********配置项目
#工程名称(Project的名字)
ProjectName=GomeShop
#scheme名字 -可以点击Product->Scheme->Manager Schemes...查看
Scheme=GomeShopDebug
#Release还是Debug
Configuration=Release
#打包日期
ArchiveDate=`date +%Y%m%d_%H%M`
#工程路径 也就是xxx.xcworkspace的路径 在.sh文件的上一级目录
Workspace=../
#build路径 编译成.xcarchive的路径
BuildDir=./Build
#plist文件名，默认放在工程文件路径的位置
PlistName=./Plist/add-hocOptionsPlist.plist
#打包类型 是AppStore类型的 还是add-hoc类型的
#ipa包的路径
ArchivePath=./add-hoc/IPA_Files
#蒲公英账号的 uKey
U_key=814bd134a0c9bd026a38d8d245a1ba38
#蒲公英账号的APPKEY
APP_KEY=d59fde4c96d1c99752cf59fa27edb80d
#ipa包的路径文件
filePath=${ArchivePath}/${ProjectName}-${ArchiveDate}/GomeShopDebug.ipa

#创建构建和输出的路径
mkdir -p ${BuildDir}
#构建 导出包 所用的路径
mkdir -p ${ArchivePath}

echo '**** 开始清理工程  ****'
xcodebuild clean -workspace  ${Workspace}/${ProjectName}.xcworkspace -scheme ${Scheme} -configuration ${Configuration}  -UseNewBuildSyetem=NO

echo '测试数据'${PlistName}
echo '**** 清理工程完毕  ****'
#pod 相关配置

#更新pod配置
#pod install

echo "打包的工程"${ProjectName}.xcworkspace
echo '**** 开始编译打包工程   ****' ${Configuration}
#构建
xcodebuild archive \
-workspace ${Workspace}/${ProjectName}.xcworkspace  \
-scheme ${Scheme} \
-configuration ${Configuration} \
-archivePath ${BuildDir}/${ProjectName}.xcarchive -quiet \
clean \
build

echo '**** 编译打包工程完毕  ****'

echo '******  开始导出IPA ******'

echo '导出的文件路径和名称'BuildDir/${ProjectName}.xcarchive
#生成ipa
xcodebuild -exportArchive \
-archivePath ${BuildDir}/${ProjectName}.xcarchive \
-exportPath ${ArchivePath}/${ProjectName}-${ArchiveDate} \
-exportOptionsPlist ${PlistName}
echo '******  导出IPA成功 ******'
open ${BuildDir}
echo '******  打开打包的目录成功 ******'

echo '******  删除编译的.xcarchive ******'
if [ -d "${BuildDir}" ]; then
rm -rf "${BuildDir}"
echo 'build文件夹删除成功'
fi


echo "IPA包的路径打印"${filePath}

echo "****** 开始上传IPA包到蒲公英 ******"
if [ -e "${filePath}" ]; then
echo "进入上传"
curl -F "file=@${filePath}" \
-F "uKey=${U_key}" \
-F "_api_key=${APP_KEY}" \
"http://www.pgyer.com/apiv1/app/upload"
echo "****** IPA包上传到蒲公英成功 ******"
else
echo "IPA包不存在 上传蒲公英失败"
fi
}
packaging "GomeShop" "GomeShop"  "Release"  "~/Desktop/GomeShop/GomeShop" "./TestBuild" "app-storeOptionsPlist.plist"
