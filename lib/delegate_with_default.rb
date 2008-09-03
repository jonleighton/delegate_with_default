class Module
  def delegate(*methods)
    options = methods.pop
    unless options.is_a?(Hash) && to = options[:to]
      raise ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter)." 
    end

    methods.each do |method|
      if options.has_key? :default
        code = "(#{to} && #{to}.__send__(#{method.inspect}, *args, &block)) || #{options[:default].inspect}" 
      else
        code = "#{to}.__send__(#{method.inspect}, *args, &block)" 
      end

      module_eval(<<-EOS, "(__DELEGATION__)", 1)
        def #{method}(*args, &block)
          #{code}
        end
      EOS
    end
  end
end
