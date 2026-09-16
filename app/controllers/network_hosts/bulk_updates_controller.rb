class NetworkHosts::BulkUpdatesController < ApplicationController
  def update
    attributes = bulk_update_params
    @network_hosts = NetworkHost.where(id: attributes.fetch(:ids, [])).to_a

    if @network_hosts.empty?
      respond_with_error "Select at least one network host."
    elsif NetworkHost::STATUSES.exclude?(attributes[:status])
      respond_with_error "Choose a valid status."
    else
      NetworkHost.transaction do
        @network_hosts.each { |network_host| network_host.update!(status: attributes[:status]) }
      end

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "#{helpers.pluralize(@network_hosts.size, "network host")} updated."
        end
        format.html do
          redirect_to network_hosts_path,
            notice: "#{helpers.pluralize(@network_hosts.size, "network host")} updated.",
            status: :see_other
        end
      end
    end
  end

  private
    def bulk_update_params
      params.expect(bulk_update: [ :status, ids: [] ])
    end

    def respond_with_error(message)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = message
          render :error, status: :unprocessable_content
        end
        format.html { redirect_to network_hosts_path, alert: message, status: :see_other }
      end
    end
end
