require 'rubygems'
require 'interactive_editor'
require 'irb/completion'
require 'looksee/shortcuts'

%w|rubygems wirble hirb|.each do|lib|
  begin
    require lib
  rescue LoadError => err
    warn "Couldn't load an irb gem: #{err}"
  end
end

# wirble (colors)
Wirble.init
Wirble.colorize

# hirb (active record)
Hirb::View.enable

# IRB Options
IRB.conf[:AUTO_INDENT] = true

# awesome_print configuration
require 'ap'
=begin
IRB::Irb.class_eval do
  def output_value
    ap @context.last_value
  end
end
=end
