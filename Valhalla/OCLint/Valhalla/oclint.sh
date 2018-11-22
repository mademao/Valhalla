export LC_ALL=en_US.UTF-8
source ~/.bash_profile

currentTime=$(date "+%Y%m%d")

workspaceName="Valhalla"
schemeName="Valhalla"

#获取输入参数
reportType="-report-type=xcode"
while getopts ":r:" opt
do
    case $opt in
    r)
    if [ "$OPTARG" = "html" ];then
        reportType="-report-type=html -o=./$schemeName/Report.html"
        rm "Report.html"
    fi
    ;;
    esac
done

#获取项目路径
PROJECT_DIR=$(cd `dirname $0`;cd ..;cd ..;pwd)
cd ${PROJECT_DIR}

buildPath="${PROJECT_DIR}/OCLint/build"
compilecommandsJsonFolderPath="${PROJECT_DIR}/OCLint"
compilecommandsJsonFilePath="${PROJECT_DIR}/OCLint/compile_commands.json"
customRuleFolderPath="${PROJECT_DIR}/OCLint/oclint_rules"

#获取默认规则路径
defaultRulePath=""
cat ~/.bash_profile | while read OCLINT_HOME
do
if [[ ${OCLINT_HOME:0:(12-0)} == "OCLINT_HOME=" ]]; then
break
fi
done
defaultRulePath=${OCLINT_HOME}"/lib/oclint/rules"


rm -rf "$compilecommandsJsonFolderPath/build"
rm "$compilecommandsJsonFilePath"

xcodebuild -workspace $workspaceName.xcworkspace -scheme $schemeName clean
xcodebuild SYMROOT=$buildPath -workspace $workspaceName.xcworkspace -scheme $schemeName -derivedDataPath $buildPath COMPILER_INDEX_STORE_ENABLE=NO | xcpretty -r json-compilation-database -o $compilecommandsJsonFilePath

cd $compilecommandsJsonFolderPath

#加载自定义文件下的规则，先创建规则文件夹
if [ ! -d oclint_rules  ];then
mkdir oclint_rules
fi

oclint-json-compilation-database \
-e Pods \
-- \
-extra-arg=-Wno-everything \
$reportType \
-R $customRuleFolderPath \
-R $defaultRulePath \
-disable-rule=AssignIvarOutsideAccessors \
-disable-rule=PreferEarlyExit \
-disable-rule=UselessParentheses \
-disable-rule=UseBoxedExpression \
-disable-rule=UseContainerLiteral \
-disable-rule=UseNumberLiteral \
-disable-rule=UseObjectSubscripting \
-disable-rule=BitwiseOperatorInConditional \
-disable-rule=UnnecessaryDefaultStatement \
-disable-rule=UnnecessaryElseStatement \
-disable-rule=UnusedMethodParameter \
-disable-rule=RedundantNilCheck \
-disable-rule=ShortVariableName \
-rc CYCLOMATIC_COMPLEXITY=10 \
-rc LONG_CLASS=1000 \
-rc LONG_LINE=200 \
-rc LONG_METHOD=100 \
-rc LONG_VARIABLE_NAME=30 \
-rc MAXIMUM_IF_LENGTH=15 \
-rc MINIMUM_CASES_IN_SWITCH=2 \
-rc NPATH_COMPLEXITY=200 \
-rc NCSS_METHOD=100 \
-rc NESTED_BLOCK_DEPTH=5 \
-rc SHORT_VARIABLE_NAME=3 \
-rc TOO_MANY_FIELDS=20 \
-rc TOO_MANY_METHODS=50 \
-rc TOO_MANY_PARAMETERS=10 \
-max-priority-1 0 \
-max-priority-2 9999 \
-max-priority-3 9999


rm -rf "$compilecommandsJsonFolderPath/build"
rm "$compilecommandsJsonFilePath"
