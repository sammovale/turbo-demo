class NetworkHostsController < ApplicationController
  include TableScoped

  table_for NetworkHost

  before_action :set_network_host, only: %i[ show edit update destroy ]

  def index
    base_query = NetworkHost.all
    filtered_query = base_query.filtered_by(table_filter_parameters)
    ordered_query = filtered_query.sorted_by(**table_order_parameters)

    @network_hosts = paginate_table(ordered_query)
    @filter_options = {
      status: NetworkHost.filter_options_for(:status),
      location: NetworkHost.filter_options_for(:location),
      device_type: NetworkHost.filter_options_for(:device_type)
    }
  end

  def show
  end

  def new
    @network_host = NetworkHost.new(status: "planned")
  end

  def edit
  end

  def create
    @network_host = NetworkHost.new(network_host_params)

    if @network_host.save
      redirect_to @network_host, notice: "Network host was created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @network_host.update(network_host_params)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "#{@network_host.hostname} was updated."
          render :update
        end
        format.html { redirect_to @network_host, notice: "Network host was updated.", status: :see_other }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, formats: :html, status: :unprocessable_content }
        format.html { render :edit, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @network_host.destroy!
    redirect_to network_hosts_path, notice: "Network host was removed.", status: :see_other
  end

  private
    def set_network_host
      @network_host = NetworkHost.find(params.expect(:id))
    end

    def network_host_params
      params.expect(network_host: [
        :hostname, :design_name, :ip_address, :mac_address, :location, :device_type,
        :vendor, :hardware_model, :operating_system, :status, :vlan_id, :notes
      ])
    end
end
