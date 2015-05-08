class RepoController < ApplicationController
skip_before_action :verify_authenticity_token, :only => [:analyse]
def index
 if !(session[:access_token].nil?)
     @name=Octokit::Client.new(:access_token => session[:access_token])
     
 end
end
 def analyse
      url=params[:r]
       puts url

   if url=~ /^https?:\/\/github.com(\/*)(\/*)/
     user_name = url.split('/')[3]
     repo_name = url.split('/')[4]
     repo_name = repo_name.split('.')[0]
     puts user_name
     puts repo_name
     octokit_config
     # user=User.create(:login => user_name)
     @repo=Octokit.repository("#{user_name}/#{repo_name}")
     @issue=Octokit.issues("#{user_name}/#{repo_name}")
      @milestones=Octokit.list_milestones("#{user_name}/#{repo_name}")
    # binding.pry
     Repository.create(:github_repository_id =>@repo.id,:name =>@repo.name,:full_name => @repo.full_name,:created_at => @repo.created_at,:updated_at => @repo.updated_at,:pushed_at => @repo.pushed_at,:has_issues => @repo.has_issues,:language => @repo.language,:open_issues_count => @repo.open_issues_count,:subscribers_count => @repo.subscribers_count ,:repository_owner_id =>@repo.owner.id)   
     #@repos.each do |s|
	#@array.push({:name => s.name,:open_issues_count => s.open_issues_count,:owner_login =>s.owner.login,:created_at => s.created_at,:updated_at =>s.updated_at,:pushed_at => s.pushed_at,:lang => s.language,:fork => s.fork})
     #end
 
    
    # @milestones_attr = []
    #@milestones.each do |a|
   #  @milestones_attr.push({:id => a.id,:number => a.number,:title => a.title,:description => a.description,:creator => a.creator.login,:open_issues =>a.open_issues,:closed_issues => a.closed_issues,:created_at => a.created_at, :updated_at => a.updated_at})
     
    # end
     
     
      
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
     redirect_to root_url
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
          
      end
   end
end
