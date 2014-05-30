class Investor < ActiveRecord::Base
  belongs_to :company
  after_create :send_user_email, if: :is_cron?

	class << self
	 def company_for_investor(user, investor)
	   companies = Investor.where(:name => investor.name).map(&:company).uniq.map(&:id)
	   user.user_companies.where("company_id in (?)", companies).map(&:company)
	 end
	end
  
  private
  
  def send_user_email
  	users_to_send_emails_to = UserCompany.where(company_id: self.company.id).map(&:user).compact.select {|u| self.user_registered?(u)}
    users_to_send_emails_to.each do |user|
    	NewInvestmentMailer.new_investment_email(user).deliver
    end	    
  end

  def user_registered?(user)
    !/guest/.match(user.email)
  end

end
