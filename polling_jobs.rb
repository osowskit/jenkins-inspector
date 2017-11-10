require "jenkins_api_client"
require "Nori"

begin
  jenkins_server = ENV.fetch("JENKINS_URL")
  jenkins_username = ENV.fetch("JENKINS_USERNAME")
  jenkins_api_token = ENV.fetch("JENKINS_API_TOKEN")
rescue Exception => e
  puts "Error: Please configure Environment Variables"
  puts "#{e}"
  exit
end

@client = JenkinsApi::Client.new(
  :server_url => jenkins_server,
  :username => jenkins_username,
  :password => jenkins_api_token
)

# The following call will return all jobs matching 'Testjob'
jobs = @client.job.list_all()

jobs.each do | job |
  #puts job
  config =  @client.job.get_config(job)
  response = Nori.new.parse(config)

  if response.key?("project") && response["project"].key?("triggers")
  
    begin
      if response["project"]["triggers"].key?("hudson.triggers.SCMTrigger")
        #puts trigger
        puts response["project"]["triggers"]["hudson.triggers.SCMTrigger"]["spec"]
      elsif response["project"]["triggers"].key?("org.jenkinsci.plugins.ghprb.GhprbTrigger")
        puts response["project"]["triggers"]["org.jenkinsci.plugins.ghprb.GhprbTrigger"]["spec"]
      end
    rescue Exception => e
      puts "#{e}"
    end
  end
end
