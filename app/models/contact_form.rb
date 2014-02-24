class ContactForm < MailForm::Base
include MailForm::Delivery

   ISSUE_TYPES = [ 
      ["General inquiry or request", "General inquiry or request"],
      ["Feedback", "Feedback"],
      ["Reporting a problem", "Reporting a problem"],
   ] 
  attribute :contact_method,  :captcha  => true
  attribute :category,    :validate => true
  attribute :name,        :validate => true
  attribute :email,       :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message,     :validate => true
  # - can't use this without ActiveRecord::Base validates_inclusion_of :issue_type, :in => ISSUE_TYPES

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "DAMS Contact Form: #{category}",
      :to => "dlp@ucsd.edu", 
      :from => %("#{name}" <#{email}>)
    }
  end
end