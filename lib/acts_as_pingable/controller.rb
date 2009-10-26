module ActsAsPingable
  module Controller
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def pings_controller(options = {})
        
        cattr_accessor :pingable_pingdom
        self.pingable_pingdom = options[:pingdom]

        cattr_accessor :pingable_secret
        self.pingable_secret = options[:secret]

        include ActsAsPingable::Controller::InstanceMethods
        
      end
      
    end
    
    module InstanceMethods
      
      def ping
        if self.pingable_secret && params[:secret] != self.pingable_secret
          render :text => 'Forbidden', :status => :forbidden  
          return
        end
        begin
          benchmark_result = Benchmark.measure do
            Ping.pinged(request.remote_ip, params[:source])
          end
          ping_response(benchmark_result.real * 1000)
        rescue => exception
          render :text => exception.message , :status => 500
        end
      end

      private
      
      def ping_response(time)
        if(self.pingable_pingdom)
          render :text => "<pingdom_http_custom_check><status>OK</status><response_time>#{ "%.3f" % time }</response_time></pingdom_http_custom_check>"
        else
          render :text => 'OK'
        end
      end
      

    end
    
  end
end
