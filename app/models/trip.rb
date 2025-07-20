
require 'httparty'

class Trip < ApplicationRecord
  belongs_to :user

  after_create :generate_openai_response
  after_create :fetch_google_place_id_and_photo

  private

  def fetch_google_place_id_and_photo
    puts "Fetching place id for: #{self.location}"

    return if self.location.blank?

    # 1. Get Place ID
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
    params = {
      input: self.location,
      inputtype: "textquery",
      fields: "place_id",
      key: ENV['GOOGLE_API_KEY']
    }
    response = HTTParty.get(url, query: params)
    puts "Google response: #{response.parsed_response.inspect}"
    candidates = response.parsed_response["candidates"]
    return if candidates.blank?

    place_id = candidates.first["place_id"]
    self.update_column(:place_id, place_id)
    puts "Saved place_id: #{place_id}"


    # 2. Get Photo Reference
    details_url = "https://maps.googleapis.com/maps/api/place/details/json"
    details_params = {
      place_id: place_id,
      fields: "photo",
      key: ENV['GOOGLE_API_KEY']
    }
    details_response = HTTParty.get(details_url, query: details_params)
    puts "Details response: #{details_response.parsed_response.inspect}"
    photos = details_response.parsed_response.dig("result", "photos")
    if photos && photos.first
      photo_reference = photos.first["photo_reference"]
      self.update_column(:place_photo_reference, photo_reference)
      puts "Saved photo_reference: #{photo_reference}"

    end
  end

  def generate_openai_response
    return if self.openai_response.present?

    # Build prompt if not present
    prompt_text = self.prompt.presence || <<~PROMPT
      Create a helpful trip guide and checklist for the trip that I am going on.
      Trip name: #{self.name}
      Location: #{self.location}
      Dates: #{self.start_date} to #{self.end_date}
      Companions: #{self.companions}
      Activity: #{self.activity}
      Extra information: #{self.extra_information}
      Please include:
      - A quick overview of the trip (be excited for the user!)
      - Checklist (format as a checklist with checkboxes)
      - Conditions (weather, temperature, things to watch out for)
      - Helpful Tips
    PROMPT

    chat = RubyLLM.chat
    chat.with_instructions <<~INSTRUCTIONS
      You are a helpful assistant that gives travel advice: I want you to provide context for the following headings, split the text so that it is formatted nicely:
      add a quick overview of the trip, you can use the trip's name as the title/heading #{self.name}, you should also be very excited for the user and their trip,
      Checklist - this is for items that the traveler needs to have (can you format this as a checklist with checkboxes),
      Conditions - This must take the dates of the user's trip and, also include temperature, weather, and any other conditions that might be helpful for the user to know including average temperatures.,
      Helpful Tips - for some extra handy information,
    INSTRUCTIONS
    chat.with_model "gpt-3.5-turbo"
    chat.with_temperature 0.9
    response = chat.ask(prompt_text)
    self.update_column(:openai_response, response.content)
  end
end
