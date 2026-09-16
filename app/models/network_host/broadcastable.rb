module NetworkHost::Broadcastable
  extend ActiveSupport::Concern

  included do
    broadcasts_refreshes
    broadcasts_refreshes_to ->(_network_host) { :network_hosts }
  end
end
