class StoneBridge::Application

  namespace '/template' do


  # get the template to json
  get '/:template_name', :provides => :json do
    json StoneBridge::Template.new.get_template(params[:template_name])
  end

  # get a json list of all the templates
  get '/' , :provides => :json do
    json StoneBridge::Template.new.list_templates
  end

  end

end