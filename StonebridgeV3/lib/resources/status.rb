class Application
  namespace '/status' do
    get ':jobid' do
      status = "jobid not recognized"
      status_file = File.join(configatron.plugins.reporter.reportsdir, "#{params[:jobid]}.yaml")
      status = YAML::load(File.open(status_file)) if File.exists?  status_file
      json status
    end

  end
end