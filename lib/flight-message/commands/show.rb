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

require 'flight-message/clusters_config'
require 'flight-message/command'
require 'flight-message/commands/reap'
require 'flight-message/config'
require 'flight-message/exceptions'
require 'flight-message/message'

module FlightMessage
  module Commands
    class Show < Command
      def run
        cluster = ClustersConfig.current

        #TODO make this asset specific if called on a single asset if speed
        # becomes an issue.
        Message.reap(cluster)

        asset_dirs = if asset = @argv.first
                       path = File.join(Config.store_dir, cluster, asset)
                       unless File.directory?(path)
                         raise ArgumentError, "Asset not found - '#{asset}'"
                       end
                       [path]
                     else
                       Dir.glob(File.join(Config.store_dir, cluster, '*'))
                     end

        asset_dirs.sort!

        asset_dirs.each { |asset_dir| output_asset(asset_dir) }
      end

      def output_asset(asset_dir)
        messages = Message.load_dir(asset_dir)
        status_msg, info = messages.partition { |m| m.data['type'] == 'status' }
        header = "##{File.basename(asset_dir)}:"

        misc = []
        unless status_msg.empty?
          mid_string = ' STATUS '
          status = status_msg[0]
          header = header + "#{mid_string}- #{status.data['text']}"
          if status.data['misc']
            # work out padding to allign text
            n = header.rindex(mid_string) + mid_string.length
            status.data['misc'].each do |key, val|
              str = "- #{key} = #{val}"
              (0...n).each { str = ' ' + str }
              misc << str
            end
          end
        end
        puts header
        puts misc unless misc.empty?

        info = info.sort_by { |m| m.data['received'] }.reverse
        info.each { |i| puts "  #{i.data['received']} - #{i.id} - #{i.data['text']}" }
        puts
      end
    end
  end
end
