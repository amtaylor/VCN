class NewInvestmentMailer < ActionMailer::Base  
  default from: 'no-reply@vcn.com'

  def new_investment_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'The company you are following just got funded!')
  end  
end