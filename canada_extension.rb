require 'ri_cal'
require 'mail_style'

class CanadaExtension < Radiant::Extension
  version "1.0"
  description "Collexion Automated Newsletter Assembly Device"
  url "http://collexion.net"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.namespace :canada do |canada|
        canada.resources :hacks
        canada.resources :events
        canada.resources :announcements
        canada.resources :locations
        canada.resources :organizations
        canada.resources :resources
        canada.resource :newsletter,
                        :member => { :send_newsletter => :post }
      end
    end

    map.canada_root '/admin/canada', :controller => 'admin/canada'
  end
  
  def activate
    admin.tabs.add "Canada", "/admin/canada", :after => "Layouts", :visibility => [:all]

    Page.send :include, EventTags
  end
  
  def deactivate
    # unused
  end
  
end
