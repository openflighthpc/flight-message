#!/bin/bash
yum install -y curl

curl https://openflighthpc.s3-eu-west-1.amazonaws.com/repos/openflight-dev/openflight.repo > /etc/yum.repos.d/openflight.repo

yum install -y flight-message

/opt/flight/bin/flenable

bash /opt/flight/opt/message/support/apache_server_conf-centos7.sh
