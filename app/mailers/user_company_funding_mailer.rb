class UserCompanyFundingMailer < ActionMailer::Base
  default from: "\"VCNemesis Team\" <funding-updates@vcnemesis.com>"

  def funding_update_email(user, company, investors)
    puts "SendingUpdates for #{user.inspect} and #{company.inspect}"
    @user      = user
    @url       = "http://www.vcnemesis.com/users/sign_in"
    @company   = company
    @investors = investors
    mail(to: @user.email, subject: "Funding update on vcnemesis!")
  end
end
