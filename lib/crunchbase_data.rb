require 'net/http'
require 'json'
module Api
 class CrunchbaseData
    CRUNCHBASE_API_KEY            = "236qvz77rth5wmmr9g2cqnhr"
    CRUNCHBASE_COMPANY_NAMESPACE  = "company"
    CRUNCHBASE_NAME_NAMESPACE     = "name"

    attr_accessor :company, :uri, :name, :api_key

    def initialize(name = "")
      self.name    = name
      self.api_key = CRUNCHBASE_API_KEY
      self.uri     = URI("http://api.crunchbase.com/v/1/company/#{name}.js?api_key=#{api_key}")
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
      funding_rounds = json_body['funding_rounds']
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
      puts "investor Data = #{investor_data}"
      unless company.nil?
        investor_data.each do |investor|
          puts "Investor = #{investor}"
          company.investors.create!(:name => investor)
        end
      end
      company.investors
    end
 end
end