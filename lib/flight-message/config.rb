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

require 'flight-message/utils'

module FlightMessage
  class Config
    class << self
      def instance
        @instance ||= Config.new
      end

      def method_missing(s, *a, &b)
        if instance.respond_to?(s)
          instance.send(s, *a, &b)
        else
          super
        end
      end

      def respond_to_missing?(s)
        instance.respond_to?(s)
      end
    end

    attr_reader :root_dir, :store_dir, :default_cluster

    def initialize
      @root_dir = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
      @store_dir = File.join(@root_dir, 'var/store')
      @cluster_config = File.join(@root_dir, 'etc/clusters.yml')
      @default_cluster = Utils.load_yaml(@cluster_config)['default']
    end
  end
end
