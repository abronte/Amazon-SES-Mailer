require "bundler"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __FILE__)
Bundler.setup(:default, :development)
Bundler.require(:default, :development)

FakeWeb.allow_net_connect = false
