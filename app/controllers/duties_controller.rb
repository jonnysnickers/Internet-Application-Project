class DutiesController < ApplicationController
  
  before_action :logged_in_user, only: [:show, :edit, :update_duty]
  before_action :correct_user,   only: [:edit, :update_duty]
  
  def show
    @duties = User.find(params[:id]).duty
    @plan = Hash.new("")
    @duties.each { |duty| @plan[duty.date] = duty.clinic.name }
  end
  
  def edit
    @doctor_id = params[:id]
    @duties = User.find(params[:id]).duty
    @plan = Hash.new("")
    @duties.each { |duty| @plan[duty.date] = duty.clinic.id }
    
    @clinics = []
    doc_cli = DocCli.where(user_id: @doctor_id)
    doc_cli.each { |dc| @clinics << dc.clinic }
    #@clinics = Clinic.all
  end
  
  def update_duty
    doc_id = params[:id]
    work = params[:workplan]
    
    ActiveRecord::Base.transaction do
      duties = User.find(doc_id).duty
      duties.each { |duty| duty.delete }
      work.each { |t,c| 
        if c != ""
          Duty.create(user_id: doc_id, clinic_id: c, date: t)
        end
      }
    end
#    rescue => e
      # something went wrong, transaction rolled back
      
    flash[:success] = "Workplan updated"
    redirect_to "/duties/#{doc_id}/edit"
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
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user) || logged_in_as_admin?
        flash[:danger] = "It looks like you don't have permission to enter this content."
        redirect_to(root_url)
      end
    end
  
  
end
