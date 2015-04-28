class RepoController < ApplicationController
skip_before_action :verify_authenticity_token, :only => [:analyse]
def index
end
 def analyse

       puts "HI"
      url=params[:r]
       puts url
   if url=~ /^https?:\/\/github.com(\/*)(\/*)/
     user_name = url.split('/')[3]
     repo_name = url.split('/')[4]
     repo_name = repo_name.split('.')[0]
     puts user_name
     puts repo_name
# client = Octokit::Client.new \
  # :client_id     => "23b7ff218482e1dda8fe",
  # :client_secret => "f514e21364160d4cd16caf4965f0eeaf1e933fc7"
 #    #@user=Octokit.user 'AyanSaha'
  #   puts "Listing all repositories of #{user_name}"
    @user=Octokit.user user_name
    @repos=Octokit.repositories(user_name)
  #   @repos.each do |repo|
  #        puts repo.name
  #     end
   
   end
 end
def create
  auth = request.env["omniauth.auth"]
  user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
  session[:user_id] = user.id
  redirect_to root_url, :notice => "Signed in!"

end
def destroy
 session[:user_id] = nil
 redirect_to root_url, :notice => "Signed out!"
end

end
