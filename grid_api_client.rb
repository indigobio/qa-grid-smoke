require 'restclient'
require 'logging'
require 'json'

class GridAPIclient

  def initialize( addr: 'http://selenium-hub.ci.indigo:4444')
    @addr = addr

    @logger = Logging.logger['GridAPIclient']
    @logger.level = :debug
    @logger.add_appenders Logging.appenders.stdout

  end

  def grid_api_hub

    url = "#{@addr}/grid/api/hub"

    @logger.info( url )
    x = request(type: :get, url: url, acceptable_codes: [200], content_type: :json, follow_redirects: true )

    @logger.info( x.inspect )

  end

  private

  def request(type: :get, url:, acceptable_codes: [200], content_type: :json, follow_redirects: true )

    params = Hash.new
    params[:method] =   type
    params[:url] =      url

    # params[:headers] =  Hash.new
    # params[:headers][:params] = query_params unless query_params.empty?
    #
    # #params[:headers][:accept] =       accept_type
    # params[:headers][:content_type] = content_type unless content_type.nil?


    RestClient::Request.execute( params ) do  |response, request, result|

      @logger.info("request - #{params.inspect}; response code - #{response.description}")

      if response.code.to_s.start_with?('3') && follow_redirects
        response = response.follow_redirection
        @logger.info("request (redirected) - response code - #{response.description}")
      end

      unless acceptable_codes.nil?

        unless acceptable_codes.include?(response.code)
          msg = "#{ response.code.to_s } - #{request} : #{ response }"
          @Logger.error( msg )
          raise msg
        end

      end

      JSON.parse( response )

    end

  end

end

