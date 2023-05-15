RSpec.describe Hotel do

  describe '.search' do
    context 'when given a valid hotel name' do
      let(:name) { 'DoubleTree Hilton Amsterdam' }

      it 'returns the URLs of the hotel from different sources' do
        urls = Hotel.search(name)

        expect(urls[0]).to start_with('https://www.tripadvisor.com/')
        expect(urls[1]).to start_with('https://www.booking.com/')
        expect(urls[2]).to start_with('https://www.holidaycheck.de/')
      end
    end
  end

end
