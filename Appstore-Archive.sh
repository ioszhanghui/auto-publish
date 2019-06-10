packaging(){

#ProjectName Scheme Configuration Workspace不能留空格
#***********配置项目
#工程名称(Project的名字)
ProjectName=GomeShop
#scheme名字 -可以点击Product->Scheme->Manager Schemes...查看
Scheme=GomeShop
#Release还是Debug
Configuration=Release
#打包日期
ArchiveDate=`date +%Y%m%d_%H%M`
#工程路径 在.sh文件的上一级目录
Workspace=../
#build路径 编译成.xcarchive的路径
BuildDir=./Build
#plist文件名，默认放在工程文件路径的位置
PlistName=./Plist/app-storeOptionsPlist.plist
#打包类型 是AppStore类型的 还是add-hoc类型的
#ipa包的路径
ArchivePath=./AppStore/IPA_Files

#创建构建和输出的路径
mkdir -p ${BuildDir}
#构建 导出包 所用的路径
mkdir -p ${ArchivePath}

echo '**** 开始清理工程  ****'
xcodebuild clean -workspace  ${ProjectName}.xcworkspace -scheme ${Scheme}  -configuration ${Configuration}  -UseNewBuildSyetem=NO

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
if [-d "${BuildDir}"]; then
rm -rf "${BuildDir}"
fi

}
packaging "GomeShop" "GomeShop"  "Release"  "~/Desktop/GomeShop/GomeShop" "./TestBuild" "app-storeOptionsPlist.plist"
