# frozen_string_literal: true

require './app/router'
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           expire_after: 2_592_000,
                           secret: 'helloworld'
use Rack::Reloader, 0
run Router
