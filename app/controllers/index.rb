# In command line

# export TWITTER_KEY=CvYJhI8Z26tUjtrLa2eQ
# export TWITTER_SECRET=kImHEFFfZh9EHq0kIM3wXfCgvFmmdyUKZrKn3EYyp4
# shotgun

get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token

  #find user...
  @user = User.where(username: @access_token.params[:screen_name]).first_or_create(oauth_token: @access_token.params[:oauth_token],
                       
  # Is user valid?                                                                                 oauth_secret: @access_token.params[:oauth_token_secret])
  if @user.valid?
    #create sessions
    session[:user_id] = @user.id
    erb :index
  end
end

