$LOAD_PATH.unshift 'lib'
require 'blog'

if ENV['URL'] and ENV['DATABASE_URL']  
GithubHook.disable :autopull
elsif Blog.production?
  require 'rack/cache'
  use Rack::Cache
end
run Blog
