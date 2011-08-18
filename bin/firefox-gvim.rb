#!/usr/bin/env ruby
#
#  Configure Firefox
#  -----------------
#
#  Open about:config in your Firefox location bar and:
#
#  * Right-Click > New > String "network.protocol-handler.app.gvim" with content firefox-gvim.rb
#
#  * Right-Click > New > Boolean "network.protocol-handler.external.gvim" with value true
#
#  Update: In Firefox 3.5 and above you have to do:
#
#  * Right-Click: New > Boolean "network.protocol-handler.expose.gvim" with value false.
#
#  Configure footnotes using this line:
#
#    Footnotes::Filter.prefix = 'gvim://open?url=file://%s&line=%d&column=%d'
#

file = ARGV.first.split('file://').last.split('&').first
line = /\&line\=(\d+)/.match(ARGV.first)[1] rescue 0
`gvim --remote-tab-silent "+#{line}" #{file}`
`wmctrl -a "GVIM"`
