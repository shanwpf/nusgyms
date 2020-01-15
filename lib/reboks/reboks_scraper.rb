require 'selenium-webdriver'
require 'yaml'
require_relative 'reboks_urls'

module Reboks
  class ReboksScraper
    def initialize
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      @driver = Selenium::WebDriver.for :chrome, options: options
      @driver.get ReboksUrls::LOGIN_URL
      @wait = Selenium::WebDriver::Wait.new(timeout: 5)
    end
    
    def start
      fill_form(Rails.application.credentials.reboks[:username], Rails.application.credentials.reboks[:password])
      submit_form
      @driver.get ReboksUrls::GYM_TICKETS_URL
    end
    
    def fill_form(username, password)
      user_input = @wait.until do
        @driver.find_element(id: 'userNameInput')
      end
      
      pwd_input = @wait.until do
        @driver.find_element(id: 'passwordInput')
      end
      
      user_input.send_keys username
      pwd_input.send_keys password
    end
    
    def submit_form
      submit_button = @wait.until do
        @driver.find_element(id: 'submitButton')
      end
      
      submit_button.click
    end
    
    def get_occupancy
      utown_occupancy = @wait.until do
        @driver.find_element(css: '#gympass > div.detail-content > div > div:nth-child(3) > b')
      end
      mpsh_occupancy = @wait.until do
        @driver.find_element(css: '#gympass > div.detail-content > div > div:nth-child(1) > b')
      end
      usc_occupancy = @wait.until do
        @driver.find_element(css: '#gympass > div.detail-content > div > div:nth-child(2) > b')
      end
      
      return {
        utown: utown_occupancy.text,
        mpsh3: mpsh_occupancy.text,
        usc: usc_occupancy.text
      }
    end
  end
end
