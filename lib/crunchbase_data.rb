require 'net/http'
require 'json'
module Api
 class CrunchbaseData
    CRUNCHBASE_API_KEY            = "236qvz77rth5wmmr9g2cqnhr"
    CRUNCHBASE_COMPANY_NAMESPACE  = "company"
    CRUNCHBASE_NAME_NAMESPACE     = "name"

    attr_accessor :company, :uri, :name, :api_key, :exited, :total_money_raised, :founded_year, :founded_month, :number_of_employees, :user

    def initialize(name = "", user, company)
      self.name    = name.gsub(' ', '-')
      self.api_key = CRUNCHBASE_API_KEY
      self.uri     = URI("http://api.crunchbase.com/v/1/company/#{self.name}.js?api_key=#{api_key}")
      self.user    = user      
    end

    def fetch
      Company.transaction do
        data = fetch_data(self.uri)
        investor_data = parse_json(data)
        create_company
        create_company_investors_for(self.user, investor_data)
      end
    end

    def fetch_data(url)
      response = Net::HTTP.get_response(URI(url))

      case response
        when Net::HTTPSuccess then
          response.body
        when Net::HTTPRedirection then
          location = response['location']
          warn "redirected to #{location}"
          fetch_data(location)
        else
          response.value
      end
    end

    def parse_json(data)
      json_body = JSON.parse(data)

      self.name = json_body['name']
      funding_rounds = json_body['funding_rounds']
      
      self.exited = !(json_body['acquisition'] ||  json_body['ipo']).nil?
      self.total_money_raised = json_body['total_money_raised']
      self.founded_year = json_body['founded_year']
      self.founded_month = json_body['founded_month']
      self.number_of_employees = json_body['number_of_employees']

      investor = []
      unless funding_rounds.nil?
        funding_rounds.each do |round|
          investments = round['investments']
          investments.each do |investment|
            investment.each do |type, value|
              unless value.nil?
                investor <<  (type == "person" ? value["first_name"] + " " + value["last_name"] : value["name"])
              end
            end
          end
        end
      end
      investor
    end

    def create_company
      self.company ||= Company.find_or_create_by_name(:name => self.name)
    end

    def create_company_investors_for(user, investor_data)
      investor_data.each do |investor|
        company.investors.create!(:name => investor)
      end
        company.exited = self.exited
        company.total_money_raised = self.total_money_raised
        company.founded_year = self.founded_year
        company.founded_month = self.founded_month
        company.number_of_employees = self.number_of_employees
        company.name = self.name
        company.save!
        user.user_companies.create!(:company => company)
        company.investors
    end

  end
end