class RepoController < ApplicationController
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
 
  #   user=Octokit.user 'AyanSaha'
 puts "Listing all repositories of #{user_name}"
    repos=Octokit.repositories(user_name)
     repos.each do |repo|
          puts repo.name
       end
     
   end
 def omni
  #use OmniAuth::Builder do
      #      provider :github, '23b7ff218482e1dda8fe', 'f514e21364160d4cd16caf4965f0eeaf1e933fc7'
    #end
   client = Octokit::Client.new \
   :client_id     => "23b7ff218482e1dda8fe",
   :client_secret => "f514e21364160d4cd16caf4965f0eeaf1e933fc7"
    redirect_to client.authorize_url("23b7ff218482e1dda8fe",:scope => "repo")
     #redirect_to client.authorize_url
  end
 end
end
