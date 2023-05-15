require_relative "hotel/version"
require 'nokogiri'
require 'watir'

module Hotel
    class << self
        def search(name)
            [tripadvisor_url(name) + " for tripadvisor.com",
            booking_url(name) + " for booking.com",
            holidaycheck_url(name) + " for holidaycheck.de"]
        end

        private

        def tripadvisor_url(name)
            url = "https://www.tripadvisor.com/Search?q=#{URI.encode_www_form_component(name)}"

            browser = Watir::Browser.new :firefox
            browser.goto url
            sleep 2
            doc = Nokogiri::HTML(browser.html)
            result = doc.css('.result-title').first.attribute('onclick').to_s
   
            url = "https://www.tripadvisor.com/"
            result = url+result[50..result.index("{type: 'HOTELS',element:")-4]

            result ? "#{result}" : nil
        end
    
        def booking_url(name)
            url = "https://www.booking.com/searchresults.en-gb.html?ss=#{URI.encode_www_form_component(name)}"

            browser = Watir::Browser.new :firefox
            browser.goto url
            sleep 2
            doc = Nokogiri::HTML(browser.html)
            result = doc.css('.e13098a59f').first.attribute('href')

            result ? "#{result}" : nil
        end
    
        def holidaycheck_url(name)
            url = "https://www.holidaycheck.de/svc/search-mixer/search?query=#{URI.encode_www_form_component(name)}&tenant=hc-search&page=%2Fhotels&scope=hotel&travelkind=hotel"

            doc = Net::HTTP.get(URI(url))
            result = JSON.parse(doc)

            url = "https://www.holidaycheck.de/"
            result = url+result["transformedResults"][0]["link"]

            result ? "#{result}" : nil
        end
    end
end