require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'

# IRB options
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 100

def import(gemname, lib=nil)
  require lib || gemname
  yield if block_given?
rescue LoadError
  candidates = ENV["GEM_PATH"].split(":").map { |p| Dir["#{p}/gems/*"] }.flatten.select do |entry|
    File.directory?(entry) && File.basename(entry).start_with?(gemname)
  end

  if candidates.empty?
    warn "Couldn't load an irb gem: #{lib || gemname}"
  else
    $:.push(candidates.sort.reverse.first + "/lib")
    require lib || gemname
    yield if block_given?
  end
end

import 'ffi'
import 'spoon'
import 'interactive_editor'

import 'looksee' do
  Looksee.editor = 'vi +%l %f'
  Looksee.styles[:overridden] = "\e[1;35m%s\e[0m"
end

import 'wirble' do
  Wirble.init
  Wirble.colorize
end

import 'hirb' do
  Hirb::View.enable
end

import 'clipboard' do
  def paste
    Clipboard.paste
  end
  class String
    def copy
      Clipboard.copy(self)
    end
  end
end

import 'awesome_print', 'ap' do
  #IRB::Irb.class_eval do
    #def output_value
      #ap @context.last_value
    #end
  #end
end


# rails ------------------------------------------------------------------------

if defined?(Rails)
  def sql(query)
    ActiveRecord::Base.sql(query)
  end

  class ActiveRecord::Base
    alias :attr :update_attribute
    def self.recent(n=10)
      limit(n).order('id desc')
    end
    def self.sql(query)
      self.connection.select_all(query)
    end
  end
end


# method tracing ---------------------------------------------------------------

def enable_trace(event_regex = /^(call|return)/,
                 class_regex = /IRB|Wirble|RubyLex|RubyToken/ )
  puts "Enabling method tracing with event regex #{event_regex.inspect}
         and class exclusion regex #{class_regex.inspect}"

  set_trace_func Proc.new{|event, file, line, id, binding, classname|
    printf "[%8s] %30s %30s (%s:%-2d)\n", event, id, classname, file, line if
      event          =~ event_regex and
      classname.to_s !~ class_regex
  }
  return
end

def disable_trace
  puts "Disabling method tracing"
  set_trace_func nil
end
