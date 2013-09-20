require 'erubis'
require 'sinatra'
require 'ridley'

require 'chef-browser/settings'

module ChefBrowser
  class App < Sinatra::Base
    set :erb, :escape_html => true
    set :root, File.expand_path(File.join(File.dirname(__FILE__), '../..'))

    # It's named this way to have variables from the `settings.rb` file
    # visible from inside the app as `settings.rb.setting_name`
    set :rb, begin
               settings_rb = Settings.new
               settings_rb.load File.join(settings.root, 'settings.rb')
               settings_rb
             end

    def chef_server
      @chef_server ||= Ridley.new(
        server_url: settings.rb.server_url,
        client_name: settings.rb.client_name,
        client_key: settings.rb.client_key)
    end

    get '/' do
      erb :index
    end

    get '/nodes' do
      erb :node_list, locals: {
        nodes: chef_server.node.all,
        environments: chef_server.environment.all
      }
    end

    get '/data_bags' do
      erb :data_bag_list, locals: {
        bags: chef_server.data_bag
      }
    end

    get '/data_bag/:data_bag_name' do
      erb :data_bag, locals: {
        bags: chef_server.data_bag,
        data_bag_name: request.path.gsub("/data_bag/", "")
      }
    end

    get '/node/:node_name' do
      erb :node, locals: {
        nodes: chef_server.node.all,
        node_name: request.path.gsub("/node/", "")
      }
    end

  end
end
