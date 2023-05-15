require_relative "hotel/version"

module Hotel
    class << self
        def search(name)
            tripadvisor_url = tripadvisor_url(name)
            booking_url = booking_url(name)
            holidaycheck_url = "" #holidaycheck_url(name)

            {
            tripadvisor: tripadvisor_url,
            booking: booking_url,
            holidaycheck: holidaycheck_url
            }
        end

        private

        def tripadvisor_url(name)
            #format: https://www.tripadvisor.com/Search?q=hotel%20casa%20do%20mar%20icapui
            url = "https://www.tripadvisor.com/Search?q=#{URI.encode_www_form_component(name)}"
            doc = Nokogiri::HTML(URI.open(url))
            result = doc.css('.result-title > a').first
            result ? "https://www.tripadvisor.com#{result['href']}" : nil
        end
    
        def booking_url(name)
            #format: https://www.booking.com/searchresults.pt-br.html?ss=hotel+casa+do+mar+icapui
            url = "https://www.booking.com/searchresults.en-gb.html?ss=#{URI.encode_www_form_component(name)}"
            doc = Nokogiri::HTML(URI.open(url))
            result = doc.css('.sr-hotel__title a').first
            result ? "https://www.booking.com#{result['href']}" : nil
        end
    
        def holidaycheck_url(name)
            #format: 
            url = "https://www.holidaycheck.de/suche?hc_query=#{URI.encode_www_form_component(name)}"
            doc = Nokogiri::HTML(URI.open(url))
            result = doc.css('.result-item > .title > a').first
            result ? result['href'] : nil
        end
    end
end