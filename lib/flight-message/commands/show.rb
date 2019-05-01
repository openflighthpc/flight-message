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
require 'flight-message/message'

module FlightMessage
  module Commands
    class Show < Command
      def run
        cluster = @options.cluster || ClustersConfig.default

        Message.reap(cluster)

        asset_dirs = Dir.glob(File.join(Config.store_dir, cluster, '*'))
        asset_dirs.sort!
        asset_dirs.each do |asset_dir|
          messages = Message.load_dir(asset_dir)
          status_msg, info = messages.partition { |m| m.data['type'] == 'status' }
          header = "##{File.basename(asset_dir)}"
          unless status_msg.empty?
            header = header + ":  STATUS - #{status_msg[0].data['text']}"
          end
          puts header
          info.sort_by { |m| m.data['received'] }
          info.each { |i| puts "  #{i.id} - #{i.data['text']} - #{i.data['received']}" }
          puts
        end
      end
    end
  end
end
