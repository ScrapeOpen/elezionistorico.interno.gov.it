setwd('ScrapeOpen/elezionistorico.interno.gov.it') # Change this!
options(warn=2) # Warnings into errors!

dir <- "raw_csv_19460602_F/" # Change this
files <- list.files(dir)

splitFileName <- function(x) {
  require(stringr)
  this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
  this_type <- this_split[1]
  this_what <- this_split[2]
  this_date <- as.character(as.Date(this_split[3], "%d_%m_%Y"))
  this_where_1 <-  this_split[4] # area
  this_where_2 <- gsub("SCRUTINI-Referendum-02_06_1946-ITALIA-ANCONA-|-Provincia\\.csv", "", x) # circoscrizione
  this_where_2 <- gsub("_", " ", this_where_2)
  return(list(type = this_type,
              election = this_what,
              date = this_date,
              geo_lev_1 = this_where_1,
              geo_lev_2 = this_where_2))
}

makeDF <- function(lst, dat) {
  details <- 
    data.frame(matrix(unlist(lst), nrow=1, byrow=T, 
                      dimnames = list(NULL, names(lst))))
  details <- 
    do.call("rbind", replicate(nrow(dat), details, simplify = FALSE))
  return(cbind(file_details, dat))
}

scrutini_dat <- data.frame()

for (f in files) {
  file_details <- splitFileName(f)
  this_dat <- read.csv(paste0(dir, f), sep = ";", row.names = NULL, colClasses = 'character')
  this_dat <- this_dat[,1:8]
  colnames(this_dat) <- 
    c("Ente", "Numero.scheda", "Repubblica", "Monarchia", "Numero.elettori", "Numero.votanti", "Schede.bianche",
      "Schede.non.valide")
  this_dat$Numero.elettori <- as.numeric(gsub("\\.", "", this_dat$Numero.elettori))
  this_dat$Numero.votanti <- as.numeric(gsub("\\.", "", this_dat$Numero.votanti))
  this_dat$Schede.bianche <- as.numeric(gsub("\\.", "", this_dat$Schede.bianche))
  this_dat$Schede.non.valide <- as.numeric(gsub("\\.", "", this_dat$Schede.non.valide))
  this_dat$Repubblica <- as.numeric(gsub("\\.", "", this_dat$Repubblica))
  this_dat$Monarchia <- as.numeric(gsub("\\.", "", this_dat$Monarchia))
  scrutini_dat <- 
    rbind(scrutini_dat, 
          makeDF(file_details, 
                 data.frame(geo_entity = this_dat$Ente,
                            registered_voters = this_dat$Numero.elettori,
                            effective_voters = this_dat$Numero.votanti,
                            blank_votes = this_dat$Schede.bianche,
                            invalid_votes = this_dat$Schede.non.valide,
                            republic_votes = this_dat$Repubblica,
                            monarchy_votes = this_dat$Monarchia,
                            stringsAsFactors = F)))
  
}

scrutini_dat$istat_nam <- 
  prov_sp$NOME_PROV[match(scrutini_dat$geo_entity, toupper(prov_sp$NOME_PROV))]

scrutini_dat$istat_nam[scrutini_dat$geo_entity == "FORLI'"] <- "Forlì"
scrutini_dat$istat_nam[scrutini_dat$geo_entity == "PESARO"] <- "Pesaro Urbino"
scrutini_dat$istat_nam[scrutini_dat$geo_entity == "REGGIO CALABRIA"] <- "Reggio di Calabria"
scrutini_dat$istat_nam[scrutini_dat$geo_entity == "REGGIO EMILIA"] <- "Reggio nell'Emilia"
scrutini_dat$istat_nam[scrutini_dat$geo_entity == "MASSA CARRARA"] <- "Massa-Carrara"

write.csv(scrutini_dat, file = 'open_csv_19460602_F.csv', row.names = FALSE)