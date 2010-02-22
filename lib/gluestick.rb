require 'rubygems'
require 'httparty'

class GlueError < RuntimeError
  attr_reader :message
  def initialize message
    @message = message
  end
end

class Glue
  include HTTParty
  base_uri 'api.getglue.com'

  attr_accessor :glue_token

  GLUE_API_VERSION = '4.5'

  def initialize()
    @method_family = nil
    @glue_token = ""
  end

  def method_missing(name, *args)
    if @method_family == nil
      # The first missing_method is the first part of the method
      @method_family = name
      # Return self to chain a second method_missing
      self
    else
      # The second missing_method is the second part of the method
      # The current API format is "/v1/part_a/part_b?params"
      method = "/v2/%s/%s" % [@method_family.to_s, name.to_s]
      @method_family = nil
      # Build HTTParty options from a hash and provide auth
      glue_params = {:version => GLUE_API_VERSION}
      glue_params.merge!({:token => @glue_token}) unless @glue_token.empty?
      glue_params.merge!(args[0]) unless args[0].nil?
      options = {:query => glue_params}
      begin
        response = self.class.get(method, options)
      rescue SocketError => desc
        raise GlueError.new("Could not connect")
      end
      # A couple convenience exceptions
      raise GlueError.new("401 Unauthorized") if response.code == 401
      raise GlueError.new("404 Not Found") if response.code == 404
      raise GlueError.new("Invalid request") unless (200..299) === response.code
      # Return the response as a hash, thanks to crack
      if '/v2/user/login' == method
        @glue_token = response['adaptiveblue']['response']['ping']['token']
      end
      response
    end
  end
end
