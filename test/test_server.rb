require 'test_helper'

class TestServer < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Silk::Server
  end

  context 'TestServer' do
    setup do
      Silk.options = { :recipe_paths => File.join(File.dirname(File.expand_path(__FILE__)), 'rakefiles') }
    end

    should "return a 404 if the rake task is not found" do
      get '/'
      assert "application/json", last_response.headers['Content-Type']
      assert last_response.not_found?
    end

    should "return a success if the rake task exists and is successfully run" do
      get '/level_1'
      assert last_response.ok?
      assert "application/json", last_response.headers['Content-Type']
      assert_equal "0", last_response.headers['X_PROCESS_EXIT_STATUS']
      assert_equal "Level 1".to_json, last_response.body.to_s
    end

    should "return a success if the rake task exists at a second level and is successfully run" do
      get '/level_1/level_2'
      assert last_response.ok?
      assert "application/json", last_response.headers['Content-Type']
      assert_equal "0", last_response.headers['X_PROCESS_EXIT_STATUS']
      assert_equal "Level 2".to_json, last_response.body
    end

    should "return a success if the rake task exists an process arguments if present" do
      get '/level_1/level_2_with_args?argument_1=1&argument_2=2'
      assert last_response.ok?
      assert "application/json", last_response.headers['Content-Type']
      assert_equal "0", last_response.headers['X_PROCESS_EXIT_STATUS']
      assert_equal ("Level 2: " + { "argument_1" => "1", "argument_2" => "2" }.inspect).to_json, last_response.body
    end

    should "return read stderr, and set the exit status, and return 500 if the rake task exists, but returns a non-zero exit code" do
      get '/errors/return'
      assert_equal 500, last_response.status
      assert "application/json", last_response.headers['Content-Type']
      assert_equal "255", last_response.headers['X_PROCESS_EXIT_STATUS']
      assert_equal "Error".to_json, last_response.body
    end
  end
end
