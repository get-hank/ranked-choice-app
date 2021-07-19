module Votes
  class App
    def initialize
      @rack_static = ::Rack::Static.new(
        lambda { [404, {}, []] },
        root: File.expand_path('../public', __dir__),
        urls: ['/']
      )
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end

        run Votes::App.new
      end.to_app
    end

    def call(env)
      # api
      response = Votes::API.call(env)

      response
      # Serve error pages or respond with API response
      # case response[0]
      # when 404, 500
      #   puts response
      #   content = @rack_static.call(env.merge('PATH_INFO' => "#{response[0]}.html"))
      #   [response[0], content[1], content[2]]
      # else
      #   response
      # end
    end
  end
end
