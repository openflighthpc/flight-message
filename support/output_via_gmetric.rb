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

def is_number?(value)
  true if Float(value) rescue false
end

show_data, _, status = Open3.capture3('/opt/flight/bin/flight message show')
unless status.exitstatus == 0
  raise RuntimeError, "Error accessing Flight Message"
end

assets_text = show_data.split(/^#/).delete_if { |a| a.empty? }

assets_text.each do |a|
  lines = a.split(/\n/)
  asset = lines.shift.match(/^(.*?):/)[1]

  ip = Open3.capture3("gethostip -d #{asset}")[0].chomp
  if not ip or ip.match(/\s+/)
    puts "ERROR: Cant' find an ip for asset '#{asset}' - skipping"
    next
  end

  key_lines = lines.partition { |line| line.match(/^\s*-/) }[0]
  key_lines.each do |line|
    key, value = line.match(/- (.*) = (.*)$/)[1..2]
    if split = value.split(' ') and split.length > 1
      value = split[0]
      unit = split[1..-1].join(' ')
    end
    type = is_number?(value) ? 'float' : 'string'
    cmd = "gmetric -S #{ip}:#{asset} -n #{key} -v #{value} -t #{type} -g flight_message"
    cmd = cmd + " -u #{unit}" if unit
    Open3.capture3(cmd)
  end
end
