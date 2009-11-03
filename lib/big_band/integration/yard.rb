require "yard"

module YARD

  module CodeObjects
    class RouteObject < MethodObject
      attr_accessor :http_verb, :http_path
    end
  end

  module Handlers

    # Displays Sinatra routes in YARD documentation.
    # Can also be used to parse routes from files without executing those files.
    module Sinatra

      # Logic both handlers have in common.
      module AbstractRouteHandler
        def self.routes
          @routes ||= []
        end
        def process
          path = http_path
          path = $1 if path =~ /^"(.*)"$/
          method_name = http_verb.upcase << " " << path
          @route = CodeObjects::RouteObject.new(namespace, method_name, scope) do |o|
            o.visibility = "public"
            o.source = statement.source
            o.signature = method_name
            o.explicit = true
            o.scope = scope
            o.add_file(parser.file, statement.line)
            o.docstring = statement.comments
            o.http_verb = http_verb.upcase
            o.http_path = path
          end
          AbstractRouteHandler.routes << @route
          register @route
        end
      end

      # Route handler for YARD's source parser.
      class RouteHandler < Ruby::Base
        include AbstractRouteHandler
        handles method_call(:get)
        handles method_call(:post)
        handles method_call(:put)
        handles method_call(:delete)
        handles method_call(:head)
        def http_verb
          statement.method_name(true).to_s
        end
        def http_path
          statement.parameters.first.source
        end
      end

      # Route handler for YARD's legacy parser.
      module Legacy
        class RouteHandler < Ruby::Legacy::Base
          include AbstractRouteHandler
          handles /\A(get|post|put|delete|head)[\s\(].*/m
          def http_verb
            statement.tokens.first.text
          end
          def http_path
            statement.tokens[2].text
          end
        end
      end

    end
  end
end