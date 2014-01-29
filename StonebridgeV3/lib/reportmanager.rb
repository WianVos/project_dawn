require 'logging'
require 'fileutils'
require 'pathname'
require 'time'

class ReportManager


  # see what the configured report dir should be
  p configatron.instance_variables
  p "test"
  @reports_dir = File.join(configatron.reportsdir, '/active')
  # if it's relative path prefix it with the basedir
  @reports_dir = File.join(configatron.basedir, @reports_dir) unless Pathname.new(@reports_dir).absolute?
  # and if it doesnot exist .. create it
  FileUtils.mkdir_p @reports_dir unless File.directory?(@reports_dir)

  # do the same for the archive
  @reports_archive =  File.join(configatron.reportsdir, '/archive')
  # if it's relative path prefix it with the basedir
  @reports_archive = File.join(configatron.basedir, @reports_archive) unless Pathname.new(@reports_archive).absolute?
  # and if it doesnot exist .. create it
  FileUtils.mkdir_p @reports_archive unless File.directory?(@reports_archive)

  # get a logger instance
  @log = Logging.logger[self]
  @log.info "loaded"
  # initialize the reports hash
  @reports = {}

  # load all reports into the reports dir
  @reports = {}
  @log.info "currently active reports #{@reports.keys}"


  # create a report file for a new order
  def self.create_report(wfid, order_hash)

    report = {}
    report['creation_time'] = timestamp
    report['status'] = {}
    order_hash['items'].each {|k, v|
      v.keys.each do |item|
       report['status']["#{k}-#{item}"] = {}
      end
    }
    @reports[wfid] = report
    add_template(wfid, order_hash)
    save_all_reports
  end

  # add the jobs template to the report
  def self.add_template(wfid, template)
    @reports[wfid]['template'] = template
    save_all_reports
  end

  # add a status to a report
  def self.add_status(wfid, item, status)
    @reports[wfid]['status'][item][timestamp] = status
    save_all_reports
  end

  # find and return the last status
  def self.get_last_items_status(wfid)
    last_status = {}
    @reports[wfid]['status'].each { | k, v|
      last_status[k] = v.max_by {|k,v| k.to_i }
    }

    return last_status

  end

  def self.get_all_last_status
    last_status = {}
    @reports.keys.each {|wfid| last_status[wfid] = get_last_items_status(wfid)}
    return last_status
  end

  #get a report by job_id
  def self.get_report(wfid)
    p @reports[wfid]
    p wfid

    @reports[wfid]['status']
  end

  # get a hash with all statusses from all acitve jobs
  def self.get_all_report
    report = {}
    @reports.keys.each {|wfid| report[wfid] = @reports[wfid]['status'] }
    return report
  end

  # load all reports from disk to a hash
  def self.load_all_reports

    report_hash = {}

    p  Dir.entries(@reports_dir).select {|f| !File.directory? f and f =~ /.yaml/ }
    report_list = Dir.entries(@reports_dir).select {|f| !File.directory? f and f =~ /.yaml/  }
    p report_list
    report_list.each { |r| @reports[r.gsub('.yaml', '')] = YAML::load_file(File.join(@reports_dir, r))}
    @log.info "loaded all reports #{list_reports}"
    return report_hash
  end

  #  save all reports to disk
  def self.save_all_reports
    @reports.each {|key, value| File.open(File.join(@reports_dir,"#{key}.yaml") , 'w+') {|f| f.write(value.to_yaml) }}
    @log.info "all reports saved to disk"
  end

  # deactivate report
  def self.move_report_inactive(wfid)
    @reports[wfid]['completion_time'] = timestamp
    @log.info "moving #{wfid} to the archive... never to be heard of again"
    File.open(File.join(@reports_archive,"#{wfid}.yaml") , 'w+') {|f| f.write(@reports[wfid].to_yaml) }
    @reports.delete(wfid)
    @log.info "removed #{wfid} from the active reports"
  end

  # return a list of all available reports
  def self.list_reports
    @reports.keys
  end

  private
  def self.timestamp
    Time.now
  end

end