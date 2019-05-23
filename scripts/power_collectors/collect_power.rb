#!/usr/bin/env ruby
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

require 'open3'
require 'socket'

targets = ['Pwr Consumption', 'Current 1', 'Current 2']

def search(text, target)
  if m = /^#{target} *\| (.*)\|(.*)$/.match(text)
    m[1].strip
  else
    nil
  end
end

server = ENV['FLIGHT_MESSAGE_SERVER'] || '10.10.0.1'

stdout, stderr, status = Open3.capture3('ipmitool sdr;')

unless status.exitstatus == 0
  raise RuntimeError, "Error executing ipmitool: '#{stderr.chomp}'"
end

data = {}
targets.each do |target|
  if value = search(stdout, target)
    data[target] = value
  end
end

query_str = data.reduce('') { |str, (k, v)| "#{str}#{k}=#{v}&" }.gsub(/&$/, '')

asset = Socket.gethostname.split('.')[0]

query_str = "asset=#{asset}&" + query_str

curl = "http://#{server}/message/exec/create_status.php?#{query_str}"

curl = curl.gsub(' ', '%20').gsub(/\s+/, '')

_, curl_stderr, curl_status = Open3.capture3("curl \"#{curl}\";")

# This doesn't detect if the curled command fails
# only if the curl itself (the connection) fails
unless curl_status.exitstatus == 0
  raise RuntimeError, "Error transferring data to headnode: '#{curl_stderr.chomp}'"
end

