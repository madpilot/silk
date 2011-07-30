require 'test_helper'

class TestRunner < Test::Unit::TestCase
  context 'TestRunner' do
    setup do
      Silk.options = { :recipe_paths => File.join(File.dirname(File.expand_path(__FILE__)), 'rakefiles') }
      ENV['format'] = nil
    end
    
    should "raise TaskNotFound exception if the task isn't found" do
      assert_raise Silk::Exceptions::TaskNotFound do
        Silk::Runner.execute('task:does:not:exist', {})
      end
    end

    should 'fill the stdout on success' do
      assert_nothing_raised do
        results = Silk::Runner.execute('level_1:level_2', {})
        assert_equal 'text', results[:stdout].strip
        assert_equal 0, results[:status].exitstatus
      end
    end
  
    should 'fill the stderr on error' do
      assert_nothing_raised do
        results = Silk::Runner.execute('errors:return', {})
        assert_equal 'Error', results[:stderr].strip
        assert_equal 1, results[:status].exitstatus
      end
    end
  end
end
