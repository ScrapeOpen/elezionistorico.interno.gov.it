from selenium import webdriver
from selenium.webdriver.firefox.options import Options

# Paste `Elezione` + `Data` URL 
base_urls = ["http://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=04/03/2018", "http://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=04/03/2018"]

# Firefox settings
options = Options()
options.set_headless(headless=True)
options.set_preference("browser.download.folderList", 2)
options.set_preference("browser.download.manager.showWhenStarting", False)
options.set_preference("browser.download.dir", '/PATH/TO/DIR') # Edit this
options.set_preference("browser.helperApps.neverAsk.saveToDisk", "text/csv")
driver = webdriver.Firefox(firefox_options=options, executable_path='/PATH/TO/geckodriver') # Edit this

# Xpaths
heading_xpath = "//*/div[@class='well sidebar-nav']/div[%s]/div[1]/div/a[1]"
section_xpath = "//*/div[@class='well sidebar-nav']/div[%s]/div[2]/div/div/ul/li/a"
csv_xpath = "//*/div[@class='well sidebar-nav']/div[%s]/div[1]/div/a[%s]"

def getSectionHeading ( level ):
  return driver.find_element_by_xpath(heading_xpath % (str(level),)).text

def getSectionTitles ( level ):
  these_as = driver.find_elements_by_xpath(section_xpath % (str(level),))
  these_titles = []
  for a in these_as:
    these_titles.append(a.get_attribute('title'))
  return these_titles

def getSectionHrefs ( level ):
  these_as = driver.find_elements_by_xpath(section_xpath % (str(level),))
  these_hrefs = []
  for a in these_as:
    these_hrefs.append(a.get_attribute('href'))
  return these_hrefs
  
def downloadCSV ( level ):
  driver.find_element_by_xpath(csv_xpath % (level, 2)).click()
  driver.find_element_by_xpath(csv_xpath % (level, 3)).click()
  
def main ( ):
  for url in base_urls:
    print(url)
    driver.get(url)
    level_3_hrefs = getSectionHrefs(3)
    for level_3_href in level_3_hrefs:
      print(level_3_href)
      driver.get(level_3_href)
      level_4_hrefs = getSectionHrefs(4)
      for level_4_href in level_4_hrefs:
        print(level_4_href)
        driver.get(level_4_href)
        level_5_hrefs = getSectionHrefs(5)
        for level_5_href in level_5_hrefs:
          print(level_5_href)
          driver.get(level_5_href)
          level_6_hrefs = getSectionHrefs(6)
          for level_6_href in level_6_hrefs:
            print(level_5_href)
            driver.get(level_6_href)
            downloadCSV(7)
            
            
main()           
            
driver.quit()
            
  
  
  
  

