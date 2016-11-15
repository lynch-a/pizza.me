require 'sinatra'
require 'json'

set :port, 80
set :environment, :development
set :server, "thin"
#set :bind, '0.0.0.0'
#set :dump_errors, false

# see http://getskeleton.com/

get '/' do

  @data = JSON.parse(
    `curl -s -k  -X 'POST' -H 'Origin: https://www.pizzahut.com' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Referer: https://www.pizzahut.com/' -b 'exp_last_visit=1469212895; exp_last_activity=1470930864; www-siteview=www; QOSESSID=24pku5pbgrrsm5ql10j0j4dq02; PHPpoolSSL=!wvCYq22+YP8Z3MA7nHzER281Z48QHRx5fprTP6++y+OB5h94WHhNKaQ/mpKEtnRlzxYPD9FGDyiljyY=' --data-binary $'{}' 'https://www.pizzahut.com/api.php/site/api_pages/api_pizzabuilder/get_global_data'`
  )

  size = ["Large", "Medium"]
  sauce = ["Regular Sauce", "Extra Sauce"]
  cheese = ["Regular Cheese", "Extra Cheese"]
  crust = []
  toppings = []

  @data["topps"].each do |i|
    if i[1]["type"] == "M" or i[1]["type"] == "V"
      toppings << i[1]["name"]
    end
  end

  @data["crusts"].each do |i|
    crust << i[1]["name"]
  end

  size = size.sample
  if (size == "Medium")
    crust.reject! {|c| c.include?("Stuffed")}
  end
  
  @pizza = {
    size: size,
    crust: crust.sample,
    sauce: sauce.sample,
    cheese: cheese.sample,
    toppings: []
  }

  (1+rand(3)).times do |i|
    choice = toppings.sample
    @pizza[:toppings] << choice
    toppings.delete(choice)
  end

  erb :index
end