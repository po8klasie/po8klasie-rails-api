# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GdyniaExtraDataClient' do
  describe '#raw_schools' do
    # We are disabling webmock because we want to connect to the real api

    it 'returns the raw data from the Gdynia API', :allow_net_connect do
      raw_data = GdyniaExtraDataClient.new.raw_schools
      expect(raw_data).to be_a(Array)
      expect(raw_data.size).to be > 0
    end

    it 'correctly processes mock data' do
      institution_type = create(:institution_type)
      institution_1 = create(:institution, institution_type: institution_type)
      institution_2 = create(:institution, institution_type: institution_type)

      mock_response_body = [
        {
          'w51' => 10,
          'wx2' => 20,
          'wx3' => 30,
          'w68' => 40,
          'w88' => 50,
          'rspo' => institution_1.rspo_institution_id
        },
        {
          'w51' => 101,
          'wx2' => 201,
          'wx3' => 301,
          'w68' => 401,
          'w88' => 501,
          'rspo' => institution_2.rspo_institution_id
        }
      ]

      stub_request(:get, 'https://edukacja.gdynia.pl/api/schools/?format=json')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: mock_response_body.to_json, headers: {})

      raw_data = GdyniaExtraDataClient.new.raw_schools

      expect(raw_data[0]['w51']).to eq(10)
      expect(raw_data[0]['wx2']).to eq(20)
      expect(raw_data[0]['wx3']).to eq(30)
      expect(raw_data[0]['w68']).to eq(40.0)
      expect(raw_data[0]['w88']).to eq(50.0)
      expect(raw_data[0]['rspo']).to eq(institution_1.rspo_institution_id)

      expect(raw_data[1]['w51']).to eq(101)
      expect(raw_data[1]['wx2']).to eq(201)
      expect(raw_data[1]['wx3']).to eq(301)
      expect(raw_data[1]['w68']).to eq(401.0)
      expect(raw_data[1]['w88']).to eq(501.0)
      expect(raw_data[1]['rspo']).to eq(institution_2.rspo_institution_id)
    end
  end
end
