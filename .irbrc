require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'

# IRB options
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 100

def import(gem)
  require gem
  yield if block_given?
rescue LoadError => e
  warn "Couldn't load an irb gem: #{e}"
end

import 'interactive_editor'

import 'looksee' do
  Looksee.editor = 'vi +%l %f'
end

import 'wirble' do
  Wirble.init
  Wirble.colorize
end

import 'hirb' do
  Hirb::View.enable
end

import 'ap' do
  #IRB::Irb.class_eval do
    #def output_value
      #ap @context.last_value
    #end
  #end
end

# method tracing ---------------------------------------------------------------

## enable tracing
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

## disable tracing
def disable_trace
  puts "Disabling method tracing"
  set_trace_func nil
end

# rails ------------------------------------------------------------------------

if defined?(Rails)
  def sql(query)
    ActiveRecord::Base.connection.select_all(query)
  end

  class ActiveRecord::Base
    alias :attr :update_attribute
  end
end
