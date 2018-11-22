#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.utils import parseaddr, formataddr
import smtplib
import sys
import os
import datetime

reload(sys)
sys.setdefaultencoding('utf-8')

def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr(( \
        Header(name, 'utf-8').encode(), \
        addr.encode('utf-8') if isinstance(addr, unicode) else addr))

scheme_name=sys.argv[1]
to_addr = []
for i in range(1, len(sys.argv)):
    to_addr.append(sys.argv[i])
current_time=datetime.datetime.now().strftime('%Y%m%d %H:%M')
file_name=Header(u'' + scheme_name + '_OCLint_Report_' + current_time + '.html', 'utf-8').encode()

htmlf=open('' + sys.path[0] + '/' + scheme_name + '/Report.html','r')
htmlcont=htmlf.read()

from_addr = os.environ['ROBOT_MAIL']
password = os.environ['ROBOT_MAIL_SQM']
server_host = os.environ['ROBOT_MAIL_SERVICE']

msg = MIMEMultipart()
msg['From'] = _format_addr(u'%s' % from_addr)
to = ','.join(to_addr)
msg['To'] = to
msg['Subject'] = Header(u'' + scheme_name + ' OCLint Report ' + current_time, 'utf-8').encode()

msg.attach(MIMEText(htmlcont, 'html', 'utf-8'))

# 添加附件就是加上一个MIMEBase，从本地读取一个图片:
with open('' + sys.path[0] + '/' + scheme_name + '/Report.html', 'rb') as f:
    # 设置附件的MIME和文件名，这里是png类型:
    mime = MIMEBase('application', 'octet-stream', filename=file_name)
    # 加上必要的头信息:
    mime.add_header('Content-Disposition', 'attachment', filename=file_name)
    mime.add_header('Content-ID', '<0>')
    mime.add_header('X-Attachment-Id', '0')
    # 把附件的内容读进来:
    mime.set_payload(f.read())
    # 用Base64编码:
    encoders.encode_base64(mime)
    # 添加到MIMEMultipart:
    msg.attach(mime)

server = smtplib.SMTP(server_host)
server.set_debuglevel(1)
server.login(from_addr, password)
server.sendmail(from_addr, to_addr, msg.as_string())
server.quit()
