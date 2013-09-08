class StaticPagesController < ApplicationController
  def home

   
user_signed_in = !session[:atoken].nil?


  end

  def help
  end

  def about
  end

  def contact
  end
end
