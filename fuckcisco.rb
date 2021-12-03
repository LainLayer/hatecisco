require "selenium-webdriver"
require "json"

class HateCisco
	URL = "https://www.netacad.com/portal/resources/packet-tracer"
	
	EMAIL_FIELD_ID    = "idp-discovery-username"
	EMAIL_SUBMIT_ID   = "idp-discovery-submit"
	PASSWORD_FIELD_ID = "okta-signin-password"
	LOGIN_BUTTON_ID   = "okta-signin-submit"

	LINK = 'div.row:nth-child(22) > div:nth-child(1) > a:nth-child(1)'
	
	DIR = "/home/#{ENV['USER']}/.cache/paru/clone/packettracer/"


	def initialize
		
		profile = Selenium::WebDriver::Firefox::Profile.new
		profile['browser.download.dir'] = DIR
		profile['browser.download.default_directory'] = DIR
		profile['browser.download.folderList'] = 2
		profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/vnd.debian.binary-package, application/zip, binary/octet-stream'

		options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
		options.add_argument('--headless')
		options.add_preference('download.directory_upgrade', true)
		options.add_preference('download.folderList', 2)
		options.add_preference('download.prompt_for_download', false)
		options.add_preference('download.dir', DIR)
		options.add_preference('download.default_directory', DIR)
		options.add_preference('browser.helperApps.neverAsk.saveToDisk', 'application/vnd.debian.binary-package, application/zip, binary/octet-stream')
	
		@dr = Selenium::WebDriver.for :firefox, capabilities: options
		@cred = JSON.parse(File.read('./credentials.json'))
		@dr.navigate.to URL		
	end

	def wait
		Selenium::WebDriver::Wait.new(:timeout => 60)
	end
	
	def run
		puts "logging in."
		email  = wait.until { @dr.find_element(:id => EMAIL_FIELD_ID) }
		submit = wait.until { @dr.find_element(:id => EMAIL_SUBMIT_ID) }

		email.send_keys @cred["email"]
		submit.click

		puts "entering password."
		pass   = wait.until { @dr.find_element(:id => PASSWORD_FIELD_ID) }
		pass.send_keys @cred["password"]

		puts "clicking log in."
		login  = wait.until { @dr.find_element(:id => LOGIN_BUTTON_ID) }
		login.click

		
		puts 'searching for file link'
		link   = wait.until { @dr.find_element(css: LINK) }
		puts 'found link, clicking and waiting for .part'
		link.click

		# wait for file to be created then disappear
		sleep 1 while Dir[DIR + '*.part'].length == 0
		puts '.part detected'	
		sleep 1 while Dir[DIR + '*.part'].length > 0
		puts '.part gone'
	end

end

HateCisco.new.run

puts 'closing.'

