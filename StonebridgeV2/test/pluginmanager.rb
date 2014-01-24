class PluginManager
  @plugins = {}

  def self.<<(plugin)
    contributor = plugin[:contributor]
    klass = plugin[:class]

    if plugin[:order] == nil
      order = 50
    else
      order = plugin[:order]
    end

    raise("Plugin #{type} already loaded") if @plugins.include?(contributor)

    if klass.is_a?(String)
      @plugins[contributor] = {:loadtime => Time.now, :class => klass, :instance => nil, :order => order }
    else
      @plugins[contributor] = {:loadtime => Time.now, :class => klass.class, :instance => klass, :order => order }
    end
  end


  def self.[](plugin)
    raise("No plugin #{plugin} defined") unless @plugins.include?(plugin)

    # Create an instance of the class if one hasn't been done before
    if @plugins[plugin][:instance] == nil
      begin
        klass = @plugins[plugin][:class]
        @plugins[plugin][:instance] = eval("#{klass}.new")
      rescue Exception => e
        raise("Could not create instance of plugin #{plugin}: #{e}")
      end
    end

    @plugins[plugin][:instance]
  end

  def self.ordering

    p @plugins

  end
end

class Plugin

  def self.inherited(klass)
    order = self.getOrder
    PluginManager << {:type => "FooPlugin", :class => klass.to_s, :order => order }
  end

  def self.getOrder

    return("60")

  end
end

class FooPlugin<Plugin

  def testMethod
    p "test"
  end

  def self.getOrder

    return("70")

  end
end

PluginManager.ordering