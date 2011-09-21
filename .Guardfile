
guard 'bundler' do
  watch('Gemfile')
end

guard 'rails', :port => 3000 do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end

guard 'annotate', :routes => true do
  watch( 'db/schema.rb' )
end

guard 'livereload' do
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(app/assets/.+\.css)\.scss}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end

guard 'shell' do
  # builds latex file to pdf and hides output
  #watch('(.*).tex') do |m|
    #`pdflatex -shell-escape #{m[0]} 1>/dev/null`
    #puts "built #{m[1]}.pdf"
  #end
end
