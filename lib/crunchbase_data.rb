require 'net/http'
require 'json'
module Api
 class CrunchbaseData
    CRUNCHBASE_API_KEY            = "236qvz77rth5wmmr9g2cqnhr"
    CRUNCHBASE_COMPANY_NAMESPACE  = "company"
    CRUNCHBASE_NAME_NAMESPACE     = "name"

    attr_accessor :company, :uri, :name, :api_key, :exited

    def initialize(name = "")
      self.name    = name.gsub(' ', '-')
      self.api_key = CRUNCHBASE_API_KEY
      self.uri     = URI("http://api.crunchbase.com/v/1/company/#{self.name}.js?api_key=#{api_key}")
    end

    def fetch
      data = fetch_data(self.uri)
      investor_data = parse_json(data)
      create_company_investors(investor_data)
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
      Rails.logger.debug "Name=#{self.name}"
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

    def create_company_investors(investor_data)
      company = Company.find_or_create_by_name(:name => self.name)
      unless company.nil?
        investor_data.each do |investor|
          company.investors.create!(:name => investor)
        end
      end
      company.exited = self.exited
      company.save!
      company.investors
    end
 end
end