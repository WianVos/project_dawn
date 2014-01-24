#TODO: make the engine more configurable
require 'pluginmanager'
require 'logging'

class WfEngine

  @engine = ""
  @log = Logging.logger[self]

  def self.start
    @log.info "starting ruote workflow engine"
    @engine = Ruote::Dashboard.new(
        Ruote::Worker.new(
            Ruote::FsStorage.new('ruote_work')))
    @engine.noisy = 'true'

    @log.info "ruote engine started: "

    @log.info "registering ruote paticipants with engine"
    # tell the pluginmanager to register his loaded plugins into ruote
    PluginManager.register_ruote_participants(@engine)


    processes.each { |wfid|
      @log.info "restarting process: #{wfid}"
      @engine.respark(wfid) }
    #processes.each { |wfid| @engine.resume(wfid, :anyway => true ) }
    #processes.each {| wfid |
    #status = @engine.process(wfid)

    #exp = status.expressions.first
    #p exp
    #}
    #engine.cancel_expression(exp.fei)
  end

  # submit an order to the engine
  def self.submit_order(pdef, hash)
    wfid = @engine.launch(
     pdef,
     'orders' => hash
    )
    return wfid
  end

  # get the processes in the active engine
  def self.processes
    @engine.process_ids
  end


  # get the process status for a job
  def self.process_status(wfid)
   @engine.process(wfid).inspect
  end

  # get a particular process
  def self.process(wfid)
    @engine.process(wfid)
  end

  def self.cancel_process(wfid)
    @engine.kill(wfid)
  end

end