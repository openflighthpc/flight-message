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
require 'flight-message/config'
require 'flight-message/command'

require 'fileutils'
require 'tty-prompt'

module FlightMessage
  module Commands
    class DeleteCluster < Command
      def run
        cluster = @argv[0]
        unless ClustersConfig.list.include?(cluster)
          raise ArgumentError, "Cluster '#{cluster}' doesn't exist"
        end
        if ClustersConfig.current == cluster
          raise ArgumentError, "Can't delete '#{cluster}' - is the current cluster"
        end

        prompt = TTY::Prompt.new
        count = Dir[File.join(Config.store_dir, cluster, '**', '*')].count do |f|
          File.file?(f)
        end
        unless prompt.no?("You are about to also delete #{count} messages - proceed?")
          FileUtils.rm_rf(File.join(Config.store_dir, @argv[0]))
        end
      end
    end
  end
end
