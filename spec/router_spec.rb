# frozen_string_literal: true

require 'rspec'
require 'rack'
require 'rack/test'
require_relative '../app/router.rb'

RSpec.describe Router do
  include Rack::Test::Methods

  describe '#route' do
    let(:app) { Router }

    context 'go to /' do
      let(:response) { get '/' }
      let(:path)     { File.expand_path('../../app/views/main.html', __FILE__) }
      let(:main_page) { File.read(path) }

      it 'returns status 200 ' do
        expect(response.status).to eq 200
      end

      it 'returns main_page in body' do
        expect(response.body).to eq main_page
      end
    end

    context "go to '/choose_difficulty' " do
      let(:response) { get '/choose_difficulty' }
      let(:path)     { File.expand_path('../../app/views/choose_difficulty.html', __FILE__) }
      let(:difficulty_page) { File.read(path) }

      it 'returns status 200 ' do
        expect(response.status).to eq 200
      end

      it 'returns difficulty_page in body' do
        expect(response.body).to eq difficulty_page
      end
    end

    context 'go to /win_game' do
      let(:response) { get '/win_game' }
      let(:path)     { File.expand_path('../../app/views/win_game.html', __FILE__) }
      let(:win_page) { File.read(path) }

      it 'returns status 200 ' do
        expect(response.status).to eq 200
      end

      it 'returns win_page in body' do
        expect(response.body).to eq win_page
      end
    end

    context 'go to /lose_game' do
      let(:response) { get '/lose_game' }
      let(:path)     { File.expand_path('../../app/views/lose_game.html', __FILE__) }
      let(:lose_page) { File.read(path) }

      it 'returns status 200 ' do
        expect(response.status).to eq 200
      end

      it 'returns lose_page in body' do
        expect(response.body).to eq lose_page
      end
    end

    context 'go to /save_form' do
      let(:response) { get '/save_form' }
      let(:path)     { File.expand_path('../../app/views/save.html', __FILE__) }
      let(:save_page) { File.read(path) }

      it 'returns status 200 ' do
        expect(response.status).to eq 200
      end

      it 'returns save_page in body' do
        expect(response.body).to eq save_page
      end
    end

    context 'go to /set_difficulty' do
      let(:env)    { { 'PATH_INFO' => '/set_difficulty' } }
      let(:router) { app.new(env) }
      before do
        allow(router.controller).to receive(:set_difficulty)
      end

      it 'cals set_difficulty method from CodebreakerController' do
        expect(router.controller).to receive(:set_difficulty)
        router.route
      end
    end

    context 'go to /play' do
      let(:env)    { { 'PATH_INFO' => '/play' } }
      let(:router) { app.new(env) }
      before do
        allow(router.controller).to receive(:play)
      end

      it 'cals play method from CodebreakerController' do
        expect(router.controller).to receive(:play)
        router.route
      end
    end

    context 'go to /make_guess' do
      let(:env)    { { 'PATH_INFO' => '/make_guess' } }
      let(:router) { app.new(env) }
      before do
        allow(router.controller).to receive(:make_guess)
      end

      it 'cals make_guess method from CodebreakerController' do
        expect(router.controller).to receive(:make_guess)
        router.route
      end
    end

    context 'go to /hint' do
      let(:env)    { { 'PATH_INFO' => '/hint' } }
      let(:router) { app.new(env) }
      before do
        allow(router.controller).to receive(:hint)
      end

      it 'cals hint method from CodebreakerController' do
        expect(router.controller).to receive(:hint)
        router.route
      end
    end

    context 'go to /save' do
      let(:env)    { { 'PATH_INFO' => '/save' } }
      let(:router) { app.new(env) }
      before do
        allow(router.controller).to receive(:save)
      end

      it 'cals save method from CodebreakerController' do
        expect(router.controller).to receive(:save)
        router.route
      end
    end

    context 'go to /statistic' do
      let(:env)    { { 'PATH_INFO' => '/statistic' } }
      let(:router) { app.new(env) }

      it 'returns statistic_heading in body' do
        expect(router.controller).to receive(:statistic)
        router.route
      end
    end

    context 'go to non-existent path' do
      let(:response) { get '/non-existent' }
      let(:not_found_msg) { 'Not Found' }
      let(:header) { { 'Content-Length' => not_found_msg.length.to_s } }

      it 'returns status 200 ' do
        expect(response.status).to eq 404
      end

      it 'returns not found message in body' do
        expect(response.body).to eq not_found_msg
      end

      it 'returns header with content length' do
        expect(response.header).to eq header
      end
    end
  end
end
