require 'rails_helper'

RSpec.describe ForecastService do
  subject(:result) { described_class.call(latitude:, longitude:) }

  let(:latitude) { 14.0022 }
  let(:longitude) { -28.0011 }
  let(:mock_response) { double("HTTParty::Response") }

  before do
    allow(OpenMeteo).to receive(:forecast)
      .with(latitude: latitude, longitude: longitude)
      .and_return(mock_response)
  end

  describe '.call' do
    context 'when weather API returns a successful response' do
      let(:current_data) do
        { 'temperature_2m' => 72.5, 'apparent_temperature' => 70.0, 'weather_code' => 0 }
      end
      let(:daily_data) do
        {
          'time' => [ '2026-05-23' ],
          'temperature_2m_max' => [ 80.0 ],
          'temperature_2m_min' => [ 60.0 ],
          'weather_code' => [ 0 ]
        }
      end

      before do
        allow(mock_response).to receive(:success?).and_return(true)
        allow(mock_response).to receive(:parsed_response).and_return({
          'current' => current_data,
          'daily' => daily_data
        })
      end

      it { is_expected.to be_a_success }

      it 'sets current forecast on context' do
        expect(result.forecasting[:current]).to eq(current_data)
      end

      it 'sets daily forecast on context' do
        expect(result.forecasting[:daily]).to eq(daily_data)
      end
    end

    context 'when weather API returns a failed response' do
      before do
        allow(mock_response).to receive(:success?).and_return(false)
      end

      it { is_expected.to be_a_failure }

      it 'sets message on context' do
        expect(result.message).to eq("Weather data unavailable")
      end
    end
  end
end