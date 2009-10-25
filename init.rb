require 'acts_as_pingable/model'
ActiveRecord::Base.send(:include, ActsAsPingable::Model)
ActionController::Base.send(:include, ActsAsPingable::Controller)
