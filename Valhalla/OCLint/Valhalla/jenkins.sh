export LC_ALL=en_US.UTF-8
source ~/.bash_profile

:<<EOF
#从输入参数中获取svn版本号
svnVersion=-1
while getopts ":s:" opt
do
    case $opt in
    s)
    svnVersion=$OPTARG
    ;;
    esac
done

#验证输入svn版本号参数
if [[ $svnVersion == *[!0-9]* || "${svnVersion}" -eq "-1" ]]; then
echo "需要输入-s参数来指定当前SVN版本号，SVN版本号需要数字"
exit
fi
EOF

#进入目标目录
DIR_PATH=$(cd `dirname $0`;pwd)
cd ${DIR_PATH}

#执行oclint检测
./oclint.sh -r html

#发送邮件
cd ..
chmod 777 sendmail.py
python sendmail.py Valhalla ismademao@gmail.com

#删除生成报告文件
cd Valhalla
rm "Report.html"


