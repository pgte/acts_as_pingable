module ActsAsPingable
  module Model
    
    def self.included(base)
      base.extend(ClassMethods)      
    end
    
    module ClassMethods
      
      
      def acts_as_pingable(opts = {})

        default_opts = {:ping_timeout_secs => 3600}
        options = opts.merge(default_opts)
        cattr_accessor :ping_timeout_secs
        self.ping_timeout_secs = options[:ping_timeout_secs] 
        
        #after_create :sweep_pings

        def self.pinged(from, source)
          ping = Ping.new
          if ping.respond_to? :from
            ping.from = from 
          end
          if ping.respond_to? :source
            ping.source = source 
          end
          ping.save!
        ensure
          self.destroy_all ['created_at < ?', Time.zone.now - ping_timeout_secs]
        end
        
        
      end

    end
    
  end
end