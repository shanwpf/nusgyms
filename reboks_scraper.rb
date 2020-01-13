require 'selenium-webdriver'
require 'interactor'
require 'yaml'
require_relative 'reboks_urls'

class ReboksScraper
    def initialize
        @driver = Selenium::WebDriver.for :chrome
        @driver.get ReboksUrls::LOGIN_URL
        @wait = Selenium::WebDriver::Wait.new(timeout: 5)
    end

    def start
        account = YAML.load_file('account.yml')
        fill_form(account['username'], account['password'])
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

        hash = {
            utown: utown_occupancy.text,
            mpsh: mpsh_occupancy.text,
            usc: usc_occupancy.text
        }
        puts hash.inspect
    end
end

scraper = ReboksScraper.new
scraper.start
scraper.get_occupancy
        