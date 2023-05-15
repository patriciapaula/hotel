require_relative "hotel/version"
require 'nokogiri'
require 'watir'

module Hotel
    class << self
        def search(name)
            tripadvisor_url = tripadvisor_url(name)
            booking_url = booking_url(name)
            #holidaycheck_url = "" #holidaycheck_url(name)

            {
            tripadvisor: tripadvisor_url,
            booking: booking_url #,
            #holidaycheck: holidaycheck_url
            }
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
            url = "https://www.holidaycheck.de/suche?hc_query=#{URI.encode_www_form_component(name)}"
            doc = Nokogiri::HTML(URI.open(url))
            result = doc.css('.result-item > .title > a').first

            #out_file = File.new("trip.html", "w")
            #out_file.puts(doc)
            #out_file.close

            #puts(name)
            #puts(URI.encode_www_form_component(name))
            #puts(result)

            result ? result['href'] : nil
        end
    end
end