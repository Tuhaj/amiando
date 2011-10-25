require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'
require 'amiando'
begin
  require 'ruby-debug'
rescue LoadError
end

require 'support/hydra_cache'
require 'support/factory'

Amiando.hydra.cache_setter &HydraCache.method(:setter)
Amiando.hydra.cache_getter &HydraCache.method(:getter)
HydraCache.revision = 2

WebMock.allow_net_connect!

HydraCache.prefix = 'Global'

module Amiando
  self.api_key = TEST_KEY = Amiando::Factory.create(:api_key, :name => 'test key').key

  TEST_USER = Amiando::Factory.create(:user, :username => "jorgellop-base-#{HydraCache.revision}@example.com")
end

HydraCache.prefix = nil
