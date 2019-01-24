require 'nokogiri'
require 'open-uri'
require "pry"
require 'csv'



class Mail

def get_townhall_urls
  array_cities_emails = []
  doc = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/val-d-oise"))
    doc.css("a.lientxt").each do |city|
      townhall_url = "http://annuaire-des-mairies.com" + city["href"][1..-1]
      array_cities_emails << get_townhall_email(townhall_url)
    end
  puts array_cities_emails.inspect
  return array_cities_emails
end

def get_townhall_email(townhall_url)
  doc = Nokogiri::HTML(open(townhall_url))
  email = doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
  city = doc.xpath("/html/body/div/main/section[1]/div/div/div/h1").text.split.first
  return Hash[city, email]
end

def save_as_csv(get_townhall_urls)

  CSV.open("db/emails.csv", "wb") do |f|
    get_townhall_urls.each do |ou|
      f << [ou.keys.join, ou.values.join]
    end 
  end 
end

def perform 
	get_townhall_urls
	save_as_csv(get_townhall_urls)
end
end