require 'rails_helper'

RSpec.describe OpenMeteo do
  let(:latitude) { 38.8941543 }
  let(:longitude) { -77.4311513 }
  let(:mock_response) { double("HTTParty::Response") }

  describe ".forecast" do
    subject { described_class.forecast(latitude: latitude, longitude: longitude) }

    before do
      allow(described_class).to receive(:get).and_return(mock_response)
    end

    it "calls GET on the OpenMeteo forecast endpoint" do
      subject

      expect(described_class).to have_received(:get).with(OpenMeteo::BASE_URL, anything)
    end

    it "sends all required query parameters" do
      subject

      expect(described_class).to have_received(:get).with(anything, query: {
        latitude: latitude,
        longitude: longitude,
        current: "temperature_2m,apparent_temperature,weather_code",
        daily: "temperature_2m_max,temperature_2m_min,weather_code",
        temperature_unit: "fahrenheit",
        forecast_days: 7,
        timezone: "auto"
      })
    end

    it "returns the API response" do
      expect(subject).to eq(mock_response)
    end
  end
end
