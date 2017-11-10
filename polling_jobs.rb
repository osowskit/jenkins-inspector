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
  key, value = response.first
  if value.key?("disabled")
    puts "Job is disabled : #{value["disabled"]}"
  end

  if value.key?("triggers") && value["triggers"] != nil

    value["triggers"].each do |trigger_key, trigger_value|

      if !trigger_value.kind_of?(String) && trigger_value.key?("spec")
        # Defer to GitHub Webhook instead of polling
        if trigger_value.key?("useGitHubHooks")
          puts "Use GitHub Hooks : #{trigger_value["useGitHubHooks"]}"
        end
        # Will this job poll if enabled
        if !trigger_value["spec"].nil?
          puts trigger_value["spec"]
        end
      end
    end
  end
end
