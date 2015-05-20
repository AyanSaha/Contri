class RepoController < ApplicationController

  skip_before_action :verify_authenticity_token, :only => [:analyse]

  def index
    if !(session[:access_token].nil?)
      @name=Octokit::Client.new(:access_token => session[:access_token])
    end
  end

  def analyse
    url=params[:r]
    if url=~ /^https?:\/\/github.com(\/*)(\/*)/
      user_name = url.split('/')[3]
      repo_name = url.split('/')[4]
      repo_name.gsub! '.git', ''
      repos=Octokit.repositories("#{user_name}")
      repo=Octokit.repository("#{user_name}/#{repo_name}")
      @contribs=Octokit.contribs("#{user_name}/#{repo_name}")
      @array =[]
      @ydata= []
      @xdata= []
      @array1=[]
      @contribs.each do |c|
        @array1.push([c.login, c.contributions])
      end
      repos.each do |s|
        @array.push({:name => s.name, :open_issues_count => s.open_issues_count, :owner_login => s.owner.login, :created_at => s.created_at, :updated_at => s.updated_at, :pushed_at => s.pushed_at, :lang => s.language, :subscriber_count => s.subscriber_count})
        @xdata.push(s.open_issues_count)
        @ydata.push(s.name)
      end
      @milestones=Octokit.list_milestones("#{user_name}/#{repo_name}")
      @user = User.find_or_create_by(:github_user_id => repo.owner.id, :github_user_login => repo.owner.login, :github_user_type => repo.owner.type)
      @repository = Repository.find_or_create_by(:github_repository_id => repo.id, :name => repo.name, :full_name => repo.full_name, :private => repo.private, :created_at => repo.created_at, :updated_at => repo.updated_at, :pushed_at => repo.pushed_at, :language => repo.language, :has_issues => repo.has_issues, :open_issues_count => repo.open_issues_count, :subscribers_count => repo.subscribers_count, :user_id => @user)
      #read milestones and store milestones details in users and milestones_tables
      @milestones.each do |m|
        #store user details of the milestones creator
        @user = User.find_or_create_by(:github_user_id => m.creator.id, :github_user_login => m.creator.login, :github_user_type => m.creator.type)
        #now linkng of milestones table with repositories table
        @miles_table= @repository.milestones.find_or_create_by(:github_milestone_id => m.id, :number => m.number, :title => m.title, :open_issues => m.open_issues, :closed_issues => m.closed_issues, :state => m.state, :created_at => m.created_at, :updated_at => m.updated_at, :due_on => m.due_on, :closed_at => m.closed_at, :user_id => @user)
      end
      commits=Octokit.commits_since("#{user_name}/#{repo_name}", (Date.today - 15).to_s)
      #calculate the individual commit and store that in contributor table
      @contribs.each do |cont|
        commit_count=0
        commits.each do |c|
          if cont.id == c.author.id
            commit_count+=1
          end
        end
        #store contributor details in user and contributors table
        @user=User.find_or_create_by(:github_user_id => cont.id, :github_user_login => cont.login, :github_user_type => cont.type)
        @contribs_table=@repository.contributors.find_or_create_by(:total_contributions => cont.contributions, :recent_contributions => commit_count, :repository_id => cont.id, :user_id => @user)
      end
      lbls = Octokit.labels("#{user_name}/#{repo_name}")
      lbls.each do |lbl|
        @repository.labels.find_or_create_by(:name => lbl.name, :color => lbl.color)
      end
      #store all  Issues details
      if repo.has_issues == true
        issue=Octokit.issues("#{user_name}/#{repo_name}")
        issue.each do |i|
          @user = User.find_or_create_by(:github_user_id => i.user.id, :github_user_login => i.user.login, :github_user_type => i.user.type)
          #check for assignee_id ,if present store its details in Users table
          assignee_id=nil
          milestone_id=nil
          if !(i.assignee.nil?)
            @a = User.find_or_create_by(:github_user_id => i.assignee.id, :github_user_login => i.assignee.login, :github_user_type => i.assignee.type)
            assignee_id = @a.id
          end
          #	#store details of assignee in users tables
          if !(i.milestone.nil?)
            @mils=@repository.milestones.find_by(:github_milestone_id => i.milestone.id)
            milestone_id=@mils.id
          end
          @issue_table = @repository.issues.find_or_create_by(:github_issue_id => i.id, :number => i.number, :title => i.title, :state => i.state, :issue_assignee_id => assignee_id, :milestone_id => milestone_id, :created_at => i.created_at, :updated_at => i.updated_at, :closed_at => i.closed_at, :user_id => @user)
          i.labels.each do |l|
            @label = @repository.labels.find_by(:name => l.name, :color => l.color)
            IssueLabel.find_or_create_by(:issue_id => @issue_table.id, :label_id => @label.id, :repository_id => @repository.id)
          end
        end
      end
      @labeldata =[]
      @labels = Label.where(:repository_id => @repository.id)
      @issuelabel = IssueLabel.where(:repository_id => @repository.id)
      @labels.each do |label|
        if ((IssueLabel.where(:repository_id => @repository.id, :label_id => label.id)).count > 0)
            @labeldata.push([label.name, (IssueLabel.where(:repository_id => @repository.id, :label_id => label.id)).count])
        end

      end

      Ngrok::Tunnel.start(port: 3000)
      @client.subscribe("https://github.com/#{user_name}/#{repo_name}/events/push")," http://5be86f16.ngrok.io/payload ")
    end
  end
def webhook
  puts "webhook method called"
  end
end
  def omni
    octokit_config
    redirect_to @client.authorize_url(ENV['GITHUB_KEY'], :scope => "repo")
  end

  def create
    result = Octokit.exchange_code_for_token(params["code"], ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'])
    session[:access_token] = result[:access_token]
    octokit_config
    redirect_to root_url
  end

  def destroy
    session[:access_token] = nil
    redirect_to root_url, :notice => "Signout!"
  end

  private

  def octokit_config
    Octokit.configure do |c|
      @client = Octokit::Client.new \
                :client_id => ENV['GITHUB_KEY'],
                :client_secret => ENV['GITHUB_SECRET']
      if session["access_token"] != nil
        c.access_token = session["access_token"]
      end
    end
  end

end