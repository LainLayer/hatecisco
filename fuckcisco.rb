require "selenium-webdriver"
require "watir"

EMAIL_FIELD_ID  = "idp-discovery-username"
EMAIL_SUBMIT_ID = "idp-discovery-submit"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://www.netacad.com/portal/resources/packet-tracer"

e_input = Watir::Wait.until { driver.find_element(:id => EMAIL_FIELD_ID)  }
f_input = Watir::Wait.until { driver.find_element(:id => EMAIL_SUBMIT_ID) }

e_input.send_keys("cockballs")

x = gets
