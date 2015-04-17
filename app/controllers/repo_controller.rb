class RepoController < ApplicationController
def index

user=params[:q]
puts user
repo=params[:r]
 puts repo
#client = Octokit::Client.new(:login => user, :password => 'Ayan#884188')
# Fetch the current user
 #render :json => client.user

 end
end
