export LC_ALL=en_US.UTF-8
source ~/.bash_profile

#获取默认规则路径
defaultRulePath=""
cat ~/.bash_profile | while read OCLINT_HOME
do
if [[ ${OCLINT_HOME:0:(12-0)} == "OCLINT_HOME=" ]]; then
break
fi
done
defaultRulePath=${OCLINT_HOME}"/lib/oclint/rules"

#获取项目路径
PROJECT_DIR=$(cd `dirname $0`;cd ..;pwd)
cd ${PROJECT_DIR}

buildPath="${PROJECT_DIR}/oclint/build"
compilecommandsJsonFolderPath="${PROJECT_DIR}/oclint"
compilecommandsJsonFilePath="${PROJECT_DIR}/oclint/compile_commands.json"
customRuleFolderPath="${PROJECT_DIR}/oclint/oclint_rules"

rm -rf "$compilecommandsJsonFolderPath/build"
rm "$compilecommandsJsonFilePath"

xcodebuild clean
xcodebuild SYMROOT=$buildPath | xcpretty -r json-compilation-database -o $compilecommandsJsonFilePath

cd $compilecommandsJsonFolderPath

#加载自定义文件下的规则，先创建规则文件夹
if [ ! -d oclint_rules  ];then
mkdir oclint_rules
fi
oclint-json-compilation-database \
-- \
-R $customRuleFolderPath \
-R $defaultRulePath \
-disable-rule=ShortVariableName \
-report-type html \
-o 1234.html \
-rc CYCLOMATIC_COMPLEXITY=5 \
-rc LONG_CLASS=1000 \
-rc LONG_LINE=300 \
-rc LONG_METHOD=100 \
-rc LONG_VARIABLE_NAME=30 \
-rc MAXIMUM_IF_LENGTH=15 \
-rc MINIMUM_CASES_IN_SWITCH=1 \
-rc NPATH_COMPLEXITY=200 \
-rc NCSS_METHOD=100 \
-rc NESTED_BLOCK_DEPTH=5 \
-rc SHORT_VARIABLE_NAME=3 \
-rc TOO_MANY_FIELDS=20 \
-rc TOO_MANY_METHODS=50 \
-rc TOO_MANY_PARAMETERS=10 \
-max-priority-1 9999 \
-max-priority-2 9999 \
-max-priority-3 9999


rm -rf "$compilecommandsJsonFolderPath/build"
rm "$compilecommandsJsonFilePath"
