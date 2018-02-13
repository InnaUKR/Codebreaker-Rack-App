# frozen_string_literal: true

require './app/router'
require 'codebreaker'
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           expire_after: 2_592_000,
                           secret: 'helloworld'
use Rack::Reloader, 0
use Rack::Static, urls: ['/assets/stylesheets'], root: 'app'
run Router
