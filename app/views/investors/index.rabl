object @investors
attributes :name
node(:companies) do |investor|
  Investor.where(:name => investor.name).map(&:company).map(&:name).uniq
end