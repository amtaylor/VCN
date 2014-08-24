require "net/http"
require "json"
module Api
 class CrunchbaseData
    BASE_URL = "http://api.crunchbase.com/v/2/"
    CRUNCHBASE_API_KEY            = "a3b542e33b8bae8c19adbe8265f15998"
    CRUNCHBASE_COMPANY_NAMESPACE  = "organization/"
    CRUNCHBASE_NAME_NAMESPACE     = "name"
    CRUNCHBASE_FUNDING_ROUND_NAMESPACE = "funding-round/"

    attr_accessor :company, :uri, :name, :api_key, :exited, :total_money_raised,
     :founded_year, :founded_month, :number_of_employees, :user, :path, :funding_round_uuid

    def initialize(name = "", user, company)
      self.name    = name.gsub(" ", "-").gsub(".", "-")
      self.api_key = CRUNCHBASE_API_KEY
      self.uri     = URI("#{BASE_URL}" + "#{CRUNCHBASE_COMPANY_NAMESPACE}" + "#{self.name}?user_key=#{api_key}")
      self.user    = user
    end

    def fetch
      data = fetch_data(self.uri)
      investor_data = parse_json(data)
      create_company
      create_company_investors_for(self.user, investor_data)
    end

    def fetch_data(url)
      response = Net::HTTP.get_response(URI(url))

      case response
        when Net::HTTPSuccess then
          response.body
        when Net::HTTPRedirection then
          location = response["location"]
          warn "redirected to #{location}"
          fetch_data(location)
        else
          response.value
      end
    end

    def parse_json(data)
      json_body = JSON.parse(data)
      api_data       = json_body["data"]
      relationships  = api_data["relationships"]
      funding_rounds = relationships["funding_rounds"]["items"]
      properties     = api_data["properties"]
      self.name                = properties["name"]
      self.total_money_raised  = properties["total_funding_usd"]
      self.number_of_employees = properties["number_of_employees"]
      self.founded_year        = properties["founded_on_year"]
      self.founded_month       = properties["founded_on_month"]

      investors = []
      unless funding_rounds.nil?
        funding_rounds.each do |round|
          self.path = round["path"]
          funding_round_uuid = path.split("/").last
          funding_data  = fetch_data(path_url_for(path, funding_round_uuid))
          investors << get_investors_from(funding_data)
        end
      end
      investors.flatten.compact.uniq
    end

    def create_company
      self.company ||= Company.find_or_create_by_name(:name => self.name)
    end

    def create_company_investors_for(user, investor_data)
      investor_data.each do |investor|
        company.investors.create!(:name => investor)
      end
      company.name                = self.name
      company.total_money_raised  = self.total_money_raised
      company.number_of_employees = self.number_of_employees
      company.founded_year        = self.founded_year
      company.founded_month       = self.founded_month
      company.save!
      user.user_companies.create!(:company => company)
      company.investors
    end

    def path_url_for(path, funding_round_uuid)
      BASE_URL + CRUNCHBASE_FUNDING_ROUND_NAMESPACE + "#{funding_round_uuid}" + "?user_key=#{self.api_key}"
    end

    def get_investors_from(funding_data)
      data          = JSON.parse(funding_data)["data"]
      relationships =  data["relationships"]
      return unless relationships.has_key?("investments")
      investments   = relationships["investments"]
      investments["items"].map do |item|
        investor = item["investor"]
        investor["type"] == "Person" ? (investor["first_name"] + " " + investor["last_name"]) : investor["name"]
      end.uniq
    end

  end
end
