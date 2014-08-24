require "net/http"
require "json"
require 'crunchbase_data'
module Api
  class FundingUpdates
    def self.check_for_updates
      begin
        companies = Company.all.select(:id, :name).uniq
        users     = UserCompany.where("company_id in (?)", companies.map(&:id)).map(&:user).compact.uniq
        companies.each do |company|
          users.each do |user|
            next if /guest/.match(user.email)
            Api::CrunchbaseData.new(company.name, user, true).fetch
          end
        end
      rescue Exception => e
        puts "Caught exception #{e.inspect}"
      end
    end
  end
end
