require 'linkedin'

class AuthController < ApplicationController

  def home
    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new("spjfk69deqdq", "XbSoycthjfePvRPS")
    request_token = client.request_token(:oauth_callback =>
                                      "http://#{request.host_with_port}/auth/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to client.request_token.authorize_url

  end

  def logout
    client = LinkedIn::Client.new("spjfk69deqdq", "XbSoycthjfePvRPS")
    if session[:atoken].nil?
     #signed out already
    else
      session[:atoken] = nil
      redirect_to root_path
    end
  end


  def profile
  	client = LinkedIn::Client.new("spjfk69deqdq", "XbSoycthjfePvRPS")
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
  	#provides the ability to access authenticated user's company field in the profile %>
 	@user = client.profile(:fields => %w(positions))
	@companies = @user.positions.all.map{|t| t.company}
  end

  def upload
  end

  def callback
    client = LinkedIn::Client.new("spjfk69deqdq", "XbSoycthjfePvRPS")
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @profile = client.profile
    # client.profile.ur
    @connections = client.connections
  end
end