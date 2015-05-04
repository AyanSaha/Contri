class RepoController < ApplicationController
skip_before_action :verify_authenticity_token, :only => [:analyse]
def index
@name=Octokit::Client.new(:access_token => session[:access_token])
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
     octokit_config
     @user=Octokit.user user_name
     @repos=Octokit.repositories(user_name)
     @contribs=Octokit::Client.new.contributors("#{user_name}/#{repo_name}")
      
   end
 end
 def omni
    octokit_config
    redirect_to @client.authorize_url(ENV['GITHUB_KEY'],:scope => "repo")
    
 end
 def create
     
     result = Octokit.exchange_code_for_token(params["code"], ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'])
     session[:access_token] = result[:access_token]
     octokit_config
     redirect_to root_url, :notice => "SignIn!"
 end
 def destroy
    session[:access_token] = nil
    redirect_to root_url, :notice =>"Signout!"
 end
private 

    def octokit_config
         puts "octokit_config called"
         Octokit.configure do |c|
           @client = Octokit::Client.new \
                :client_id     =>  ENV['GITHUB_KEY'],
                :client_secret => ENV['GITHUB_SECRET']
            if session["access_token"] != nil
               c.access_token = session["access_token"]    
             end 
           if @user != nil
               c.user = @user
                   puts c.user
           end
         if @repo != nil
            c.repo = @repo
          end
      end
   end
end
