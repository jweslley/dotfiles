require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'

# IRB options
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb_history')

# rails ------------------------------------------------------------------------

if defined?(Rails)
  log_path = Rails.root.join('log', '.irb_history.log')

  IRB.conf[:HISTORY_FILE] = FileUtils.touch(log_path).join

  app_class = Rails.application.class
  app_name = if app_class.respond_to?(:module_parent)
               app_class.module_parent
             else
               app_class.parent
             end
  prompt = "#{app_name}[#{Rails.env}]"

  # defining custom prompt
  IRB.conf[:PROMPT][:RAILS] = {
    :PROMPT_I => "#{prompt}>> ",
    :PROMPT_N => "#{prompt}> ",
    :PROMPT_S => "#{prompt}* ",
    :PROMPT_C => "#{prompt}? ",
    :RETURN   => " => %s\n"
  }

  # Setting our custom prompt as prompt mode
  IRB.conf[:PROMPT_MODE] = :RAILS

  def change_log(stream)
    ActiveRecord::Base.logger = Logger.new(stream)
    ActiveRecord::Base.clear_active_connections!
  end

  def show_log
    change_log(STDOUT)
  end

  def hide_log
    change_log(nil)
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

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
