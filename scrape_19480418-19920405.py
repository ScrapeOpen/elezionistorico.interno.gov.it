from selenium import webdriver
from selenium.webdriver.firefox.options import Options
import glob
import os
import re
import time

# Set dirs and paths
download_dir = '/Users/143852/Downloads/19480418-19920405' # EDIT THIS
exec_file = '/Users/143852/Downloads/geckodriver' # EDIT THIS

# Paste `Elezione` + `Data` URL 
base_urls = ["https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=18/04/1948", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=18/04/1948", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=07/06/1953", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=25/05/1958", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=19/05/1968", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=07/05/1972", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=20/06/1976", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=03/06/1979", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=26/06/1983", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=14/06/1987", "https://elezionistorico.interno.gov.it/index.php?tpel=C&dtel=05/04/1992", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=07/06/1953", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=25/05/1958", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=19/05/1968", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=07/05/1972", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=20/06/1976", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=03/06/1979", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=26/06/1983", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=14/06/1987", "https://elezionistorico.interno.gov.it/index.php?tpel=S&dtel=05/04/1992"]

# Firefox settings
options = Options()
options.set_headless(headless=True)
options.set_preference("browser.download.folderList", 2)
options.set_preference("browser.download.manager.showWhenStarting", False)
options.set_preference("browser.download.dir", download_dir)
options.set_preference("browser.helperApps.neverAsk.saveToDisk", "text/csv")
driver = webdriver.Firefox(firefox_options=options, executable_path=exec_file)

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

def downloadCandidateCSV ( level ):
  
  list_of_files = glob.glob(download_dir + '/*.csv')
  latest_file = max(list_of_files, key=os.path.getctime)
  this_file = re.sub(r"/LISTE|/SCRUTINI", "/CANDIDATI", latest_file)
  this_file_con = open(this_file, "w")
  this_file_con.write("Ente;Candidato;Voti;Perc;\n")
  
  these_titles = getSectionTitles(level)
  these_hrefs = getSectionHrefs(level)
  for this_href in these_hrefs:
    driver.get(this_href)
    these_trs = driver.find_elements_by_xpath("//*/tr[@class='leader']")
    for this_tr in these_trs:
      place = these_titles[these_hrefs.index(this_href)]
      candidate = this_tr.find_element_by_xpath(".//td[@headers='hcandidato']").text
      votes = this_tr.find_element_by_xpath(".//td[contains(@headers, 'hvoti')]").text
      perc = this_tr.find_element_by_xpath(".//td[contains(@headers, 'hpercentuale')]").text
      this_file_con.write(place + ";" + candidate + ";" + votes + ";" + perc + ";\n")
      
  this_file_con.close()
    
def downloadCSV ( level ):
  time.sleep(10)
  driver.find_element_by_xpath(csv_xpath % (level, 2)).click()
  time.sleep(5)
  driver.refresh()
  time.sleep(10)
  driver.find_element_by_xpath(csv_xpath % (level, 3)).click()
  time.sleep(5)
  # downloadCandidateCSV(level)
  
def scrapeItalia ( ):
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
          try:
            downloadCSV(6)
          except:
            pass

# Temp fix  (Valle D'Aosta must be downloaded almost manually)        
def scrapeValleDAosta ( ):
  url = base_urls[1]
  print(url)
  driver.get(url)
  level_3_hrefs = getSectionHrefs(3)
  level_3_href = level_3_hrefs[1]
  print(level_3_href)
  driver.get(level_3_href)
  level_4_hrefs = getSectionHrefs(4)
  for level_4_href in level_4_hrefs:
    print(level_4_href)
    driver.get(level_4_href)
    downloadCSV(5)
      
scrapeItalia()        

# scrapeValleDAosta()
            
driver.quit()
            
  
  
  
  

