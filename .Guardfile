
guard 'bundler' do
  watch('Gemfile')
end

guard 'rails', :port => 3000 do
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch(%r{config/environments/.+\.rb})
  watch(%r{config/initializers/.+\.rb})
end

guard 'annotate', :routes => false do
  watch( 'db/schema.rb' )
end

guard 'livereload' do
  watch('config/routes.rb')
  watch(%r{app/.+\.(erb|haml|slim)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(app/assets/.+\.css)\.(scss|less)}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end

#guard 'ctags-bundler', :src_path => ["app", "lib", "spec/support"] do
  #watch(/^(app|lib|spec\/support)\/.*\.rb$/)
  #watch('Gemfile.lock')
#end

guard 'shell' do
  # builds latex file to pdf and hides output
  #watch('(.*).tex') do |m|
    #`pdflatex -shell-escape #{m[0]} 1>/dev/null`
    #puts "built #{m[1]}.pdf"
  #end
end
