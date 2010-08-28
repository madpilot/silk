require 'rexml/document'

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

class ProcessResult
  attr_accessor :stdout, :stderr, :exitstatus

  def initialize(stdout, stderr, exitstatus)
    @stdout = stdout
    @stderr = stderr
    @exitstatus = exitstatus
  end

  def to_json
    {
      :stdout => self.stdout,
      :stderr => self.stderr,
      :exitstatus => self.exitstatus
    }.to_json
  end

  def to_xml
    doc = REXML::Document.new
    doc.add(REXML::XMLDecl.new)
    result = REXML::Element.new('process_result')

    stdOutEl = REXML::Element.new('stdout')
    stdOutEl.add_text(self.stdout.to_s)
    
    stdErrEl = REXML::Element.new('stderr')
    stdErrEl.add_text(self.stderr.to_s)
    
    exitStatusEl = REXML::Element.new('exitstatus')
    exitStatusEl.add_text(self.exitstatus.to_s)
    
    result.add_element(stdOutEl)
    result.add_element(stdErrEl)
    result.add_element(exitStatusEl)
    
    doc.add(result);
    doc.to_s
  end

  def to_s
    self.stdout || self.stderr
  end
end

# Allows you to set different outputs based on the requested format.
# Supports xml, json and text
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

def run(command)
  stdout_read, stdout_write = IO.pipe
  stderr_read, stderr_write = IO.pipe

  pid = Process.fork do
    $stdout.reopen stdout_write
    $stderr.reopen stderr_write
    stdout_read.close
    stderr_read.close
    Kernel.exec command
  end
  
  stdout_write.close
  stderr_write.close
  
  stdout = ''
  stdout_read.each do |line|
    stdout += line
  end
  stderr = ''
  stderr_read.each do |line|
    stderr += line
  end
  pid, status = Process.waitpid2(pid)

  return ProcessResult.new(stdout, stderr, status.exitstatus)
end
