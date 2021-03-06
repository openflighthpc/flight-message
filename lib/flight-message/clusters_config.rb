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

require 'flight-message/config'
require 'flight-message/exceptions'

module FlightMessage
  module ClustersConfig
    class << self
      def current
        if c = clusters['current']
          c
        else
          default
        end
      end

      def current=(cluster)
        data = load
        data['current'] = cluster
        yaml = data.to_yaml
        File.open(path, 'w') { |f| f.write(yaml) }
      end

      def default
        if c =  clusters['default']
          c
        else
          raise ConfigError, "No default cluster set in config file"
        end
      end

      def list
        clusters = Dir.glob(File.join(Config.store_dir, '*')).map do |p|
          File.basename(p)
        end
        clusters << current unless clusters.include?(current)
        clusters
      end

      def path
        Config.cluster_config_path
      end

      private
      def clusters
        @clusters ||= load
      end

      def load
        unless File.readable?(path)
          raise ConfigError, <<-ERROR.chomp
Cluster config at #{path} is inaccessible
        ERROR
        end
        load_cluster_config(path)
      end

      def load_cluster_config(f)
        Utils.load_yaml(f).tap do |contents|
          unless contents.is_a?(Hash)
            raise ConfigError, <<-ERROR.chomp
Cluster config at #{f} is in an incorrect format
            ERROR
          end
        end
      end
    end
  end
end
