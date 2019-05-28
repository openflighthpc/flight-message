#!/bin/bash
# =============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Message.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Message is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Message. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Message, please visit:
# https://github.com/openflighthpc/flight-message
# ==============================================================================

if [[ $# -eq 0 ]] ; then
  echo 'Please provide the address of the server - exiting'
  exit 0
fi

mkdir -p /opt/service/message/

yum install -y curl ruby

curl https://raw.githubusercontent.com/openflighthpc/flight-message/master/scripts/collectors/collect_power.rb > /opt/service/message/collect_power.rb

chown root:root /opt/service/message/collect_power.rb
chmod 700 /opt/service/message/collect_power.rb

echo "#!/bin/bash" > /etc/cron.hourly/flight_message_collect_power
echo "export FLIGHT_MESSAGE_SERVER=$1 && /opt/service/message/collect_power.rb" >> /etc/cron.hourly/flight_message_collect_power

chown root:root /etc/cron.hourly/flight_message_collect_power
chmod 700 /etc/cron.hourly/flight_message_collect_power
