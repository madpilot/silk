class FormattedResponse
  def method_missing(symbol, *args, &blk)
    if [ :json, :xml, :text ].include?(symbol)
      if block_given?
        instance_variable_set("@#{symbol.to_s}", yield)
      else
        instance_variable_get("@#{symbol.to_s}")
      end
    else
      super
    end
  end
end

# Allows you to set different outputs based on the requested format.
# SUpports xml, json and text
# 
#   respond_to do |format|
#     format.xml { '<xml>xml</xml>' }
#     format.json { '{ json }' }
#     format.text { 'text' }
#   end
#
def respond_to(&blk)
  response = FormattedResponse.new
  yield(response)
  case(ENV['format'])
  when 'xml'
    puts response.xml
  when 'json'
    puts response.json
  else
    puts response.text
  end
end

# Allows you to set different error outputs based on the requested format.
# SUpports xml, json and text
# 
#   error_respond_to do |format|
#     format.xml { '<xml>xml</xml>' }
#     format.json { '{ json }' }
#     format.text { 'text' }
#   end
#
def error_respond_to(&blk)
  response = FormattedResponse.new
  yield(response)
  case(ENV['format'])
  when 'xml'
    $stderr.puts response.xml
  when 'json'
    $stderr.puts response.json
  else
    $stderr.puts response.text
  end
end
