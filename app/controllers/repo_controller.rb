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
 end
end
