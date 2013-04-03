class SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  # respond_to :json

  def create
    respond_to do |format|
      format.html { super }
      format.xml {
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        render :status => 200, :xml => { :session => { :error => "Success", :auth_token => current_user.authentication_token }}
      }

      format.json {
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
        render :status => 200,
        :json => { :success => true,
          :info => "Logged in",
          :data => { :auth_token => current_user.authentication_token } }
        }
      end

    end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    respond_to do |format|
      format.html { super }
      format.json {
        render :status => 200,
            :json => { :success => true,
                      :info => "Logged out",
                      :data => {} } }
    end

  end

  def failure
    respond_to do |format|
      format.html { super }
      format.json {
        render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
      }
    end
  end
end
