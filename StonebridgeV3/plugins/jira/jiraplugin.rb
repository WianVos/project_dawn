#TODO: what happens when the jira issue is deleted

require 'plugin'

class Jira < Plugin

   @stages = ['create', 'check']
   @order = "60"
   @participant_matcher = 'Jira'
   @items = ['jetty', 'mq', 'db2', 'il']

   def initialize
     @done_status_string = "Opgelost"
     @jira = JiraBackend.new
     @jira_template_path = File.join(File.dirname(__FILE__),'templates')
   end

   def on_workitem

     # initialize settings

     task =  workitem[:params]['task']
     item =  workitem[:params]['item']
     type = workitem[:params]['type']
     config = workitem[:params]['config']




     wfid = workitem.wfid

     if task == 'create'

      unless workitem.fields["#{item}"]['info'].has_key?('JiraIssue')
       #issueNr = @jira.createIssue(description="#{task}: #{item}",summary=get_summary_msg(item, workitem.fields["#{item}"]['settings'] ), labels=["#{wfid}", "#{item}"]  )
       issueNr = @jira.createIssue(description=get_description_msg(item, workitem.fields["#{item}"]['settings'] ),summary="#{task}: #{item}", labels=["#{wfid}", "#{item}"]  )

       #p workitem['fields']['orders']['items'][@type][@item]
       workitem.fields["#{item}"]['info']['JiraIssue'] = issueNr
       workitem.fields["#{item}"]['info']['JiraIssueStatus'] = @jira.getIssueStatus(issueNr)
       workitem.fields["#{item}"]['info']['JiraDone'] = false
      end
     end

     if task == 'check'
       issueNr = workitem.fields["#{item}"]['info']['JiraIssue']
       current_status =  @jira.getIssueStatus(issueNr)
       workitem.fields["#{item}"]['info']['JiraIssueStatus'] = @jira.getIssueStatus(issueNr)
       workitem.fields["#{item}"]['info']['JiraDone'] = true if current_status == @done_status_string
     end

     reply
   end

   def get_description_msg(item, settings)
     item_type = item.split('-')[0]

     @application = workitem.fields['orders']['applicatienaam']
     @omgeving = 'tst'

     workitem.fields["#{item}"]['settings'].each { |k, v| instance_variable_set("@#{k}", v)}
     template_path = File.join(@jira_template_path, "#{item_type}_description.erb")

     if File.exists?(template_path)
       template = ERB.new File.new(template_path).read, nil, "%"
     else
       template =  ERB.new "Template for this item type not defined"
     end
     template.result(get_binding)
   end

   def get_binding # this is only a helper method to access the objects binding method
     binding
   end


end

