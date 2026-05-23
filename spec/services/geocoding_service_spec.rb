require 'rails_helper'

RSpec.describe GeocodingService do
  subject(:result) { described_class.call(city: city, state: state) }

  let(:city) { "Chantilly" }
  let(:state) { "VA" }

  describe ".call" do
    context "when geocoder finds coordinates" do
      let(:geocoder_result) { instance_double("Geocoder::Result::Base", coordinates: [-77.4311513, 38.8941543]) }

      before do
        allow(Geocoder).to receive(:search).with("#{city}, #{state}").and_return([geocoder_result])
      end

      it { is_expected.to be_a_success }

      it "sets latitude on context" do
        expect(result.latitude).to eq(-77.4311513)
      end

      it "sets longitude on context" do
        expect(result.longitude).to eq(38.8941543)
      end
    end

    context "when geocoder returns no results" do
      before do
        allow(Geocoder).to receive(:search).and_return([])
      end

      it { is_expected.to be_a_failure }

      it "sets message on context" do
        expect(result.message).to eq("Place not found")
      end
    end

    context "when geocoder result has blank coordinates" do
      let(:geocoder_result) { instance_double("Geocoder::Result::Base", coordinates: [nil, nil]) }

      before do
        allow(Geocoder).to receive(:search).and_return([geocoder_result])
      end

      it { is_expected.to be_a_failure }

      it "sets message on context" do
        expect(result.message).to eq("Place not found")
      end
    end
  end
end
