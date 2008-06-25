require 'rubygems'
require 'active_support'
require 'action_controller'
require 'action_view'
require 'html/document'
require 'rspec_hpricot_matchers'

require File.dirname(__FILE__) + '/../lib/basic_helpers'

Spec::Runner.configure do |config|
  config.include(RspecHpricotMatchers)
end
