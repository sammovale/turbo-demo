class NetworkHosts::StatusesController < ApplicationController
  before_action :set_network_host

  def edit
  end

  def update
    if @network_host.update(status_params)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "#{@network_host.hostname} status was updated."
          render :update
        end
        format.html { redirect_to @network_host, notice: "Status was updated.", status: :see_other }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, formats: :html, status: :unprocessable_content }
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  private
    def set_network_host
      @network_host = NetworkHost.find(params.expect(:network_host_id))
    end

    def status_params
      params.expect(network_host: [ :status ])
    end
end
