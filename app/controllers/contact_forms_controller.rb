class ContactFormsController < ApplicationController
  
  def new
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.request = request
    # not spam and a valid form
    logger.warn "*** MARK ***"
    if !@contact_form.spam? && @contact_form.deliver
      flash.now[:notice] = 'Thank you for your message! You message has been sent.'
      after_deliver
      render :new
    else
      flash[:error] = 'Sorry, this message was not sent successfully. ' 
      flash[:error] << @contact_form.errors.full_messages.map { |s| s.to_s }.join(", ")
      render :new
    end
  rescue 
      flash[:error] = 'Sorry, this message was not delivered.'
      render :new
  end

  def after_deliver
     return unless false
  end
  
  private
  
  def contact_params
    params.require(:contact_form).permit!
  end
  
end




 
