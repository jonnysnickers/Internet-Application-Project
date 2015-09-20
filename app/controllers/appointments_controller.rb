class AppointmentsController < ApplicationController
  
  before_action :logged_in_user
  before_action :correct_user,   only: [:show, :new_appointment, :new_appointment2, :user_appointments, :make_appointment_doc, :make_appointment_cli ]
  before_action :correct_user2,  only: [:create_appointment, :enable_appointment, :destroy_appointment]
  
  def show
    @appointments = Appointment.where( { doctor_id: params[:id], enabled: "y" } )
  end
  
  def new_appointment
    @patient_id = params[:id]
    @doctors = User.where(ttype: "doctor")
    @clinics = Clinic.all
  end
  
  def new_appointment2
    @patient_id = params[:id]
    @clinic_id = params[:app_data][:clinic]
    @doctor_id = params[:app_data][:user]
    
    duties = Duty.where( { clinic_id: @clinic_id, user_id: @doctor_id } )
    clear_appointments
    beg_of_week = DateTime.now.beginning_of_week.to_i 
    now = DateTime.now.to_i
    
    @apps = []
    (0..4).each { |i| 
      duties.each { |d|
        tmp = Appointment.new(patient_id: @patient_id, doctor_id: @doctor_id, clinic_id: @clinic_id, date: Time.at(beg_of_week + i*604800 + 60*d.date), enabled: "n")
        if( tmp.date.to_i > now && tmp.valid?)
          @apps << tmp
        end
      }
    }
    if @apps.empty?
      flash[:danger] = "No available appointments that meet your criteria."
      redirect_to "/new_appointment/#{@patient_id}"
    end
  end
  
  def create_appointment
    
    p_id = params[:app_data2][:patient_id]
    d_id = params[:app_data2][:doctor_id]
    c_id = params[:app_data2][:clinic_id]
    date = params[:app_data2][:appointment]
    
    app = Appointment.new(patient_id: p_id, doctor_id: d_id, clinic_id: c_id, date: date, enabled: "n")
    
    begin
      app.save
      flash[:success] = "Appointment created, please confirm it."
      redirect_to "/user_appointments/#{p_id}"
    end
    rescue
      flash[:danger] = "It was impossible to create this appointment. Please try again."
      redirect_to "/new_appointment/#{p_id}"
  end
  
  def user_appointments
    @app_n = Appointment.where(patient_id: params[:id], enabled: "n")
    @app_y = Appointment.where(patient_id: params[:id], enabled: "y")
  end
  
  def enable_appointment
    appointment = Appointment.find(params[:id])
    appointment.enabled = "y" unless appointment.nil?
    if !appointment.nil? && appointment.save
      flash[:success] = "Appointment confirmed."
      redirect_to "/user_appointments/#{params[:app_data2][:patient_id]}"
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to "/user_appointments#{params[:app_data2][:patient_id]}"
    end
  end
  
  def destroy_appointment
    appointment = Appointment.find(params[:id])
    if !appointment.nil? && appointment.destroy
      flash[:success] = "Appointment deleted."
      redirect_to "/user_appointments/#{params[:app_data2][:patient_id]}"
    else
      flash[:danger] = "Something went wrong, please try again."
      redirect_to "/user_appointments/#{params[:app_data2][:patient_id]}"
    end
  end
  
  def make_appointment_doc
    @patient_id = params[:id]
    @doctor_id = params[:app_data][:user]
    
    duties = Duty.where(user_id: @doctor_id)
    clear_appointments
    beg_of_week = DateTime.now.beginning_of_week.to_i 
    now = DateTime.now.to_i
    
    stop = 0
    (0..4).each { |i| 
      duties.each { |d|
        tmp = Appointment.new(patient_id: @patient_id, doctor_id: @doctor_id, clinic_id: d.clinic_id, date: Time.at(beg_of_week + i*604800 + 60*d.date), enabled: "n")
        if( tmp.date.to_i > now && tmp.valid?)
          begin
            tmp.save
            stop = 1
          rescue
            stop = 2
          end
        end
        break if stop != 0
      }
      break if stop != 0
    }
    if stop == 0
      flash[:danger] = "No termin found. Please try again later."
      redirect_to "/new_appointment/#{@patient_id}"
    elsif stop == 1
      flash[:success] = "Appointment created, please confirm it."
      redirect_to "/user_appointments/#{@patient_id}"
    else
      flash[:danger] = "It was impossible to create appointment. Please try again."
      redirect_to "/new_appointment/#{@patient_id}"
    end
  end
  
  def make_appointment_cli
    @patient_id = params[:id]
    @clinic_id = params[:app_data][:clinic]
    
    duties = Duty.where(clinic_id: @clinic_id)
    clear_appointments
    beg_of_week = DateTime.now.beginning_of_week.to_i 
    now = DateTime.now.to_i
    
    stop = 0
    (0..4).each { |i| 
      duties.each { |d|
        tmp = Appointment.new(patient_id: @patient_id, doctor_id: d.user_id, clinic_id: @clinic_id, date: Time.at(beg_of_week + i*604800 + 60*d.date), enabled: "n")
        if( tmp.date.to_i > now && tmp.valid?)
          begin
            tmp.save
            stop = 1
          rescue
            stop = 2 
          end
        end
        break if stop != 0
      }
      break if stop != 0
    }
    if stop == 0
      flash[:danger] = "No termin found. Please try again later."
      redirect_to "/new_appointment/#{@patient_id}"
    elsif stop == 1
      flash[:success] = "Appointment created, please confirm it."
      redirect_to "/user_appointments/#{@patient_id}"
    else
      flash[:danger] = "It was impossible to create appointment. Please try again."
      redirect_to "/new_appointment/#{@patient_id}"
    end
  end
  
  
private
  def clear_appointments
    apps = Appointment.all
    now = DateTime.now.to_i
    apps.each { |a| 
      if a.created_at.to_i + 600 < now && a.enabled == "n"
        a.destroy
      end
    }
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
    
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) || logged_in_as_admin?
        flash[:danger] = "It looks like you don't have permission to enter this content."
        redirect_to(root_url)
      end
    end
    
    def correct_user2
      @user = User.find(params[:app_data2][:patient_id])
      unless current_user?(@user) || logged_in_as_admin?
        flash[:danger] = "It looks like you don't have permission to enter this content."
        redirect_to(root_url)
      end
    end
    
  
end
