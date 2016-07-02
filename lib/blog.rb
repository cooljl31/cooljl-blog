require "sinatra/base"
require "github_hook"
require "ostruct"
require "time"

class Blog < Sinatra::Base
  use GithubHook

  File.expand_path('../../', __FILE__)
  set :articles, []
  set :app_file, __FILE__

  # loop trhough all the article file
  Dir.glob "#{root}/articles/*.md" do |file|
    # parse meta date and content from file
    meta, content = File.read(file).split("\n\n", 2)

    # generate the metadate Object
    article = OpenStruct.new YAML.load(meta)

    # convert the data to a time Object
    article.date = Time.parse article.date.to_s

    # add the content
    article.content = content

    # generate a slug for the url
    article.slug = File.basename(file, '.md')

    # set up the root
    get "/#{article.slug}" do
      erb :post, :locals => { :article => article }
    end
    # Add article to the list of articles
    articles << article
  end

  # sot article by date display new article first
  articles.sort_by! { |article| article.date }
  articles.reverse!

  get '/' do
    erb :index
  end
end
