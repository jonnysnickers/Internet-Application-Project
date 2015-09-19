class AdminPanelsController < ApplicationController
  before_action :logged_in_user, only: [:main_panel, :patients_panel, :enable_patient, :destroy_patient, :doctors_panel, :new_doctor, :create_doctor, :destroy_doctor, :clinics_panel, :new_clinic, :create_clinic, :destroy_clinic, :appointments_panel, :destroy_appointment, :doc_cli_panel, :create_doc_cli, :destroy_doc_cli]
  before_action :admin_user,   only: [:main_panel, :patients_panel, :enable_patient, :destroy_patient, :doctors_panel, :new_doctor, :create_doctor, :destroy_doctor, :clinics_panel, :new_clinic, :create_clinic, :destroy_clinic, :appointments_panel, :destroy_appointment, :doc_cli_panel, :create_doc_cli, :destroy_doc_cli]
  
  def main_panel
  end
  
  def patients_panel
    @patient_enabled = User.where(ttype: "patient", enabled: "y")
    @patient_disebled = User.where(ttype: "patient", enabled: "n")
  end
  
  def enable_patient
    user = User.find(params[:id])
    user.enabled = "y" unless user.nil?
    if !user.nil? && user.save
      flash[:success] = "User enabled."
      redirect_to "/admin_patients"
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to "/admin_patients"
    end
  end
  
  def destroy_patient
    user = User.find(params[:id])
    if !user.nil? && user.destroy
      flash[:success] = "User deleted."
      redirect_to "/admin_patients"
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to "/admin_patients"
    end
  end
  
  def doctors_panel
    @doctors = User.where(ttype: "doctor")
  end
  
  def new_doctor
    @user = User.new
  end
  
  def create_doctor
    @user = User.new(user_params)
    @user[:enabled] = "y"
    @user[:ttype] = "doctor"
    if @user.save
      flash[:success] = 'Doctor added.'
      redirect_to '/admin_doctors'
    else
      render 'new_doctor'
    end
  end
  
  def destroy_doctor
    user = User.find(params[:id])
    if !user.nil? && user.destroy
      flash[:success] = "User deleted."
      redirect_to "/admin_doctors"
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to "/admin_doctors"
    end
  end
  
  def clinics_panel
    @clinics = Clinic.all
  end
  
  
  def new_clinic
    #stay with user so that error messages show
    @user = Clinic.new
  end
  
  def create_clinic
    @user = Clinic.new(clinic_params)
    if @user.save
      flash[:success] = 'Clinic added.'
      redirect_to '/admin_clinics'
    else
      render 'new_clinic'
    end
  end
  
  def destroy_clinic
    clinic = Clinic.find(params[:id])
    if !clinic.nil? && clinic.destroy
      flash[:success] = "Clinic deleted."
      redirect_to "/admin_clinics"
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to "/admin_clinics"
    end
  end
  
  def appointments_panel
    @appointments = Appointment.all
  end
  
  def destroy_appointment
    appointment = Appointment.find(params[:id])
    if !appointment.nil? && appointment.date.to_i > DateTime.now.to_i && appointment.destroy
      flash[:success] = "Clinic deleted."
      redirect_to "/admin_appointments"
    else
      if !appointment.nil? && appointment.date.to_i < DateTime.now.to_i
        flash[:danger] = "You can't delete appointments from past."
      else
        flash[:danger] = "Something went wrong, please try again."
      end
      redirect_to "/admin_appointments"
    end
  end
  
  def doc_cli_panel
    @doctors = User.where(ttype: "doctor")
    @clinics = Clinic.all
    @doc_cli = DocCli.all
    @new_doc_cli = DocCli.new
  end
  
  def create_cli_doc
    par = doc_cli_params
    begin
      DocCli.create(user_id: par[:user], clinic_id: par[:clinic])
      flash[:success] = 'Doc-Cli added.'
      redirect_to '/admin_doc_cli'
    end
    rescue => e
      flash[:danger] = 'Doc-Cli must be unique.'
      redirect_to '/admin_doc_cli'
  end
  
  def destroy_doc_cli
    doc_cli = DocCli.find(params[:id])
    if !doc_cli.nil? && doc_cli.destroy
      flash[:success] = "Doc-Cli deleted."
      redirect_to "/admin_doc_cli"
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to "/admin_doc_cli"
    end
  end
  
  
  
  
  
  private
  # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # Confirms the correct user.
    def admin_user
      unless logged_in_as_admin?
        flash[:danger] = "It looks like you don't have permission to enter this content."
        redirect_to(root_url)
      end
    end
  
end


private
    def user_params
      params.require(:user).permit(:firstname, :lastname, :pesel, :address, :username, :password, :password_confirmation, :enabled, :ttype)
    end
    
    def clinic_params
      params.require(:clinic).permit(:name)
    end
    
    def doc_cli_params
      params.require(:doc_cli).permit(:user, :clinic)
    end