class RepoController < ApplicationController
<<<<<<< HEAD
 skip_before_filter :verify_authenticity_token, :only => [:analyse]
def index
@code=params[:code]
@name=Octokit::Client.new(:access_token => session[:access_token])
     # @name=@name.login
      # puts @name.login

end
def analyse
 puts "HI"
 url=params[:r]
 puts url
 
=======
skip_before_action :verify_authenticity_token, :only => [:analyse]
def index
end
 def analyse

       puts "HI"
      url=params[:r]
       puts url
>>>>>>> ccaeed13cb169915fe90c446bb71f39b86c9df21
   if url=~ /^https?:\/\/github.com(\/*)(\/*)/
     user_name = url.split('/')[3]
     repo_name = url.split('/')[4]
     repo_name = repo_name.split('.')[0]
     puts user_name
     puts repo_name
<<<<<<< HEAD
     octokit_config
     @user=Octokit.user user_name
     @repos=Octokit.repositories(user_name)
puts "contributors"
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
=======
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

>>>>>>> ccaeed13cb169915fe90c446bb71f39b86c9df21
end
