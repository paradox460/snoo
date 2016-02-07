require 'require_all'

require 'snoo/version'

require 'snoo/support/dsl'
require 'snoo/support/helpers'
require 'snoo/support/base_client'

require_rel 'snoo/components/*.rb'

require 'snoo/client'

module Snoo
  def self.client
    Client.new
  end
end
