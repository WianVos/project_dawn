#requires go here
require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'net/http'
require 'fileutils'
require 'yaml'

# Description of the plugin

# task Description

# data emission Description


class Reporter < Ruote::Participant

  def initialize
    @reports_dir = '/tmp/stonebridge/reports'
  end

  def on_workitem
    item =  workitem[:params]['item'] 
    plugins = workitem[:params]['plugins']
    wfid = workitem.wfid

    # intialize the report hash
    report = {}

    # load the report yaml if it exsits into the report hash
    report_file = File.join(@reports_dir, "#{wfid}.yaml")
    report = YAML::load(File.open(report_file)) if File.exists?(report_file)

    # create the key for our  item if it does not exist
    report[item] = {} unless report.has_key?(item)

    # 
    report[item] = workitem.fields[item]['info']

    File.open(report_file, "w") do |f|
        f.write(report.to_yaml)
    end   
    # hand the workitem back to the engine
    reply

  end
  



end