setwd('/Users/francesco/public_git/ScrapeOpen/elezionistorico.interno.gov.it')
options(warn=2) # Warnings into errors!

dir <- "/Users/francesco/Desktop/projects/scrape_archivio_elezioni/raw_csv_20180304/" # Change this
files <- list.files(dir)

# Check files
library(stringr)
filename_head <- str_extract(files, "^[A-Z]+-[A-Z][a-z]+")
table(filename_head)
## Missing
files_camera <- files[grepl("Camera", files)]
files_camera_scrutini <- gsub("SCRUTINI-", "", files_camera[grepl("SCRUTINI", files_camera)])
files_camera_liste <- gsub("LISTE-", "", files_camera[grepl("LISTE", files_camera)])
files_camera_candidati <- gsub("CANDIDATI-", "", files_camera[grepl("CANDIDATI", files_camera)])
files_camera_scrutini[!files_camera_scrutini %in% files_camera_candidati]

files_senato <- files[grepl("Senato", files)]
files_senato_scrutini <- gsub("SCRUTINI-", "", files_senato[grepl("SCRUTINI", files_senato)])
files_senato_liste <- gsub("LISTE-", "", files_senato[grepl("LISTE", files_senato)])
files_senato_candidati <- gsub("CANDIDATI-", "", files_senato[grepl("CANDIDATI", files_senato)])
files_senato_scrutini[!files_senato_scrutini %in% files_senato_liste]

# Check if all candidates are present

# 
library(rgdal)
camera_sp = readOGR('/Users/francesco/public_git/ScrapeOpen/elezionistorico.interno.gov.it', layer = 'open_shp_20180304_camera') # Change this
senato_sp = readOGR('/Users/francesco/public_git/ScrapeOpen/elezionistorico.interno.gov.it', layer = 'open_shp_20180304_senato') # Change this
camera_sp@data$cu2017_lab <- str_trim(toupper(camera_sp@data$cu2017_lab))
senato_sp@data$su2017_lab <- str_trim(toupper(senato_sp@data$su2017_lab))


splitFileName <- function(x) {
  require(stringr)
  x <- gsub("FRIULI-VENEZIA", "FRIULI~VENEZIA", x)
  x <- gsub("EMILIA-ROMAGNA", "EMILIA~ROMAGNA", x)
  x <- gsub("TRENTINO-ALTO", "TRENTINO~ALTO", x)
  this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
  this_type <- this_split[1]
  this_what <- this_split[2]
  this_date <- as.character(as.Date(this_split[3], "%d_%m_%Y"))
  this_where_1 <-  this_split[4] # area
  this_where_2 <- gsub("_", " ", this_split[5]) # circoscrizione
  this_where_3 <- gsub("_", " ", paste(this_split[6:7], collapse = "-")) # collegio pluri
  this_where_4 <- gsub("_", " ", str_extract(x, "-\\d{2}_[A-Z\\-](.*)-Comune\\.csv")) # collegio uni
  this_where_4 <- gsub("^-|-Comune.csv", "", this_where_4)
  if (grepl('AOSTA', x)) {
    this_where_2 <- "VALLE D'AOSTA"
    this_where_3 <- "VALLE D'AOSTA - 01"
    this_where_4 <- "01 - VALLE D'AOSTA"
  }
  return(list(type = this_type,
              election = this_what,
              date = this_date,
              geo_lev_1 = gsub("([A-Z])~([A-Z])", "\\1-\\2", this_where_1),
              geo_lev_2 = gsub("([A-Z])~([A-Z])", "\\1-\\2", this_where_2),
              geo_lev_3 = gsub("([A-Z])~([A-Z])", "\\1-\\2", this_where_3),
              geo_lev_4 = gsub("([A-Z])~([A-Z])", "\\1-\\2", this_where_4)))
}

makeDF <- function(lst, dat) {
  details <- 
    data.frame(matrix(unlist(lst), nrow=1, byrow=T, 
                      dimnames = list(NULL, names(lst))))
  details <- 
    do.call("rbind", replicate(nrow(dat), details, simplify = FALSE))
  return(cbind(file_details, dat))
}

candidati_dat <- data.frame()
scrutini_dat <- data.frame()
liste_dat <- data.frame()

for (f in files) {
  require(zoo)
  file_details <- splitFileName(f)
  this_dat <- read.csv(paste0(dir, f), sep = ";", row.names = NULL, colClasses = 'character')
  if (file_details[['type']] == 'CANDIDATI') {
    this_dat <- this_dat[,1:3]
    colnames(this_dat) <- c('Ente', 'Candidato', 'Voti')
    this_dat$Voti <- as.numeric(gsub("\\.", "", this_dat$Voti))
    candidati_dat <- 
      rbind(candidati_dat, 
            makeDF(file_details, 
                   data.frame(geo_entity = this_dat$Ente,
                              candidate = this_dat$Candidato,
                              candidate_votes = this_dat$Voti,
                              stringsAsFactors = F)))
  } else if (file_details[['type']] == 'SCRUTINI') {
    this_dat <- this_dat[,1:5]
    colnames(this_dat) <- 
      c("Ente", "Numero.elettori", "Numero.votanti", "Schede.bianche",
        "Schede.non.valide")
    this_dat$Numero.elettori <- as.numeric(gsub("\\.", "", this_dat$Numero.elettori))
    this_dat$Numero.votanti <- as.numeric(gsub("\\.", "", this_dat$Numero.votanti))
    this_dat$Schede.bianche <- as.numeric(gsub("\\.", "", this_dat$Schede.bianche))
    this_dat$Schede.non.valide <- as.numeric(gsub("\\.", "", this_dat$Schede.non.valide))
    scrutini_dat <- 
      rbind(scrutini_dat, 
            makeDF(file_details, 
                   data.frame(geo_entity = this_dat$Ente,
                              registered_voters = this_dat$Numero.elettori,
                              effective_voters = this_dat$Numero.votanti,
                              blank_votes = this_dat$Schede.bianche,
                              invalid_votes = this_dat$Schede.non.valide,
                              stringsAsFactors = F)))
  } else if (file_details[['type']] == 'LISTE') {
    this_dat <- this_dat[,1:4]
    colnames(this_dat) <- c("Ente", "Candidato", "Liste.Gruppi", "Voti")
    if (file_details$geo_lev_1 == "VALLE_D'AOSTA") {
      colnames(this_dat) <- c("Ente", "Candidato","Voti",  "Liste.Gruppi")
    }
    this_dat$Voti <- as.numeric(gsub("\\.", "", this_dat$Voti))
    this_dat$Candidato <- as.character(this_dat$Candidato)
    this_dat$Candidato[this_dat$Candidato == ""] <- NA
    this_dat$Candidato <- na.locf(this_dat$Candidato)
    liste_dat <- 
      rbind(liste_dat, 
            makeDF(file_details, 
                   data.frame(geo_entity = this_dat$Ente,
                              candidate = this_dat$Candidato,
                              party_votes = this_dat$Voti,
                              party = this_dat$Liste.Gruppi,
                              stringsAsFactors = F)))
  }
}

# Trim
for (var in colnames(liste_dat)) {
  if(is.numeric(liste_dat[[var]])) next
  liste_dat[[var]] <- str_trim(liste_dat[[var]])
}
for (var in colnames(scrutini_dat)) {
  if(is.numeric(scrutini_dat[[var]])) next
  scrutini_dat[[var]] <- str_trim(scrutini_dat[[var]])
}
for (var in colnames(candidati_dat)) {
  if(is.numeric(candidati_dat[[var]])) next
  candidati_dat[[var]] <- str_trim(candidati_dat[[var]])
}

# Check candidate-location
library(dplyr)
vars <- c("candidate", "geo_entity")
res <- inner_join(unique(liste_dat[,vars]), unique(candidati_dat[,vars]))

# Check for duplicates
dup <- duplicated(candidati_dat[,vars]) | duplicated(candidati_dat[,vars], fromLast = T)
# View(candidati_dat[dup,'vars']) # CANDIDATO NON PRESENTE Add this to notes

# Check votes
sum(liste_dat$party_votes[liste_dat$election=='Camera'])
31648908
sum(candidati_dat$candidate_votes[candidati_dat$election=='Camera'])
32907395 # (ON website `totale candidati`: 32841025 + 66370 = 32907395) 

sum(liste_dat$party_votes[liste_dat$election=='Senato'])
29175241
sum(candidati_dat$candidate_votes[candidati_dat$election=='Senato'])
30272301 # (ON website `totale candidati`: 30210363 + 61938 = 30272301) 

library(dplyr)
check_liste_votes <- 
  liste_dat %>%
  group_by(election, geo_lev_4, geo_entity) %>%
  summarize(tot_liste = sum(party_votes))
check_candidati_votes <- 
  candidati_dat %>%
  group_by(election, geo_lev_4, geo_entity) %>%
  summarize(tot_candidati = sum(candidate_votes))
check_votes <- merge(check_liste_votes, check_candidati_votes, by = c('election','geo_lev_4','geo_entity'))
check_votes$test <- check_votes$tot_liste <=  check_votes$tot_candidati # This test must be passed by all entities

# Check stats
sum(scrutini_dat$registered_voters[scrutini_dat$election == 'Camera']) # ON website 46505350 + 99547
sum(scrutini_dat$effective_voters[scrutini_dat$election == 'Camera']) # ON website  33923321 + 71947
sum(scrutini_dat$blank_votes[scrutini_dat$election == 'Camera']) # ON website 389441 + 2057
sum(scrutini_dat$invalid_votes[scrutini_dat$election == 'Camera']) # ON website 1082296 + 5577	

sum(scrutini_dat$registered_voters[scrutini_dat$election == 'Senato']) # ON website 42780033 + 92087
sum(scrutini_dat$effective_voters[scrutini_dat$election == 'Senato']) # ON website  31231814	 + 66670
sum(scrutini_dat$blank_votes[scrutini_dat$election == 'Senato']) # ON website 376765 + 1631
sum(scrutini_dat$invalid_votes[scrutini_dat$election == 'Senato']) # ON website 1021451 + 4732

# Notes: Invalid votes include blank votes

#
wikidata_dict <- 
  c('Q47729' = "PARTITO DEMOCRATICO", 
    'Q47090559' = "+EUROPA",
    'Q46624077' = "ITALIA EUROPA INSIEME",
    'Q47389793' = "CIVICA POPOLARE LORENZIN",            
    'Q47750' = "LEGA",
    'Q14924303' = "FORZA ITALIA",
    'Q1757843' = "FRATELLI D'ITALIA CON GIORGIA MELONI",
    'Q46997473' = "NOI CON L'ITALIA - UDC",              
    'Q47817' = "MOVIMENTO 5 STELLE",
    'Q44929224' = "LIBERI E UGUALI", 
    'Q46217506' = "POTERE AL POPOLO!",
    'Q25648673' = "CASAPOUND ITALIA",
    'Q24213849' = "IL POPOLO DELLA FAMIGLIA",
    'Q54486970' = "PARTITO VALORE UMANO", 
    'Q48616256' = "ITALIA AGLI ITALIANI",
    'noentity1' = "10 VOLTE MEGLIO",
    'noentity2' = "AUTODETERMINATZIONE",
    'noentity3' = "BLOCCO NAZIONALE PER LE LIBERTA'",
    'noentity4' = "FI -FRAT. D'IT. -MOV.NUOVA VALLE D'AOSTA",
    'noentity5' = "GRANDE NORD",
    'noentity6' = "ITALIA NEL CUORE",
    'noentity7' = "LISTA DEL POPOLO PER LA COSTITUZIONE",
    'noentity8' = "PARTITO COMUNISTA",
    'Q767560' = "PARTITO REPUBBLICANO ITALIANO - ALA",
    'Q54542522' = "PATTO PER L'AUTONOMIA",
    'noentity9' = "PD-UV-UVP-EPAV",
    'noentity10' = "PER UNA SINISTRA RIVOLUZIONARIA",
    'Q48967423' = "POUR TOUS PER TUTTI PE TCHEUT",
    'noentity11' = "RINASCIMENTO MIR",
    'noentity12' = "RISPOSTA CIVICA",
    'noentity13' = "SIAMO",
    'Q606620' = "SVP - PATT",
    'noentity14' = "DEMOCRAZIA CRISTIANA",
    'noentity15' = "SMS - STATO MODERNO SOLIDALE",
    'noentity16' = "DESTRE UNITE - FORCONI")

# Assign wikidata entity for parties
liste_dat$party_wd_id <- 
  names(wikidata_dict)[match(liste_dat$party, wikidata_dict)]

# Find coalitions
unique_list <- unique(liste_dat[,c('party','candidate','geo_lev_4')])
require(dplyr)
unique_list <- 
  unique_list %>%
  dplyr::group_by(candidate, geo_lev_4) %>%
  dplyr::summarise(coalition = paste(party[order(party)], collapse="", ""))

coalition_df <- data.frame(party = wikidata_dict,
                           party_wd_id = names(wikidata_dict),
                           coalition = wikidata_dict,
                           stringsAsFactors = F)

coalition_df$coalition[coalition_df$party %in% 
                         c("FORZA ITALIA",
                           "FRATELLI D'ITALIA CON GIORGIA MELONI",
                           "LEGA",
                           "NOI CON L'ITALIA - UDC")] <- "Centro-destra"

coalition_df$coalition[coalition_df$party %in% 
                         c("+EUROPA", 
                           "CIVICA POPOLARE LORENZIN", 
                           "ITALIA EUROPA INSIEME", 
                           "PARTITO DEMOCRATICO")] <- "Centro-sinistra"

coalition_df$coalition_wd_id <- coalition_df$party_wd_id 
coalition_df$coalition_wd_id[coalition_df$coalition == 'Centro-destra'] <- 'Q47490603'
coalition_df$coalition_wd_id[coalition_df$coalition == 'Centro-sinistra'] <- 'Q16538868'

unique_list$coalition <- str_trim(unique_list$coalition)
unique_list$coalition_wd_id <- NA
unique_list$coalition_wd_id <- 
  coalition_df$coalition_wd_id[match(unique_list$coalition, coalition_df$coalition)]

unique_list$coalition_wd_id[grepl('FORZA ITALIA', unique_list$coalition)] <- 'Q47490603'
unique_list$coalition_wd_id[grepl('+EUROPA', unique_list$coalition)] <- 'Q16538868'


unique_list$coalition <- 
  coalition_df$coalition[match(unique_list$coalition_wd_id, coalition_df$coalition_wd_id)]

# Assign coalition details to liste_dat and candidati_dat
liste_dat <- 
  merge(liste_dat, coalition_df[,c('party_wd_id', 'coalition', 'coalition_wd_id')], by = 'party_wd_id')
candidati_dat <- 
  merge(candidati_dat, unique_list, by = c("candidate","geo_lev_4"))

liste_dat$coalition[grepl("AOSTA", liste_dat$geo_lev_4) & liste_dat$party == 'LEGA'] <- "LEGA"
liste_dat$coalition_wd_id[grepl("AOSTA", liste_dat$geo_lev_4) & liste_dat$party == 'LEGA'] <- "Q47750"

## LEGA in Valle D'Aosta not in coalition 
candidati_dat$coalition_wd_id[is.na(candidati_dat$coalition_wd_id)] <- "Q47750"
candidati_dat$coalition[is.na(candidati_dat$coalition)] <- "LEGA"

# Split camera and senato 
scrutini_camera_dat <- subset(scrutini_dat, election == 'Camera')
liste_camera_dat <- subset(liste_dat, election == 'Camera')
candidati_camera_dat <- subset(candidati_dat, election == 'Camera')

scrutini_senato_dat <- subset(scrutini_dat, election == 'Senato')
liste_senato_dat <- subset(liste_dat, election == 'Senato')
candidati_senato_dat <- subset(candidati_dat, election == 'Senato')

# Label resions for matching with geographic file
labelRegion <- function(x) {
  library(stringr)
  x <- gsub("[0-9]","",x)
  x <- str_trim(x)
  x <- str_to_title(x)
  if (grepl('trentino',x,ignore.case = T)) {
    x <- "Trentino-Alto Adige/Südtirol"
  } else if(grepl('aosta',x,ignore.case = T)) {
    x <- "Valle d'Aosta/Vallée d'Aoste"
  }
  return(x)
}

scrutini_camera_dat$region <- 
  sapply(scrutini_camera_dat$geo_lev_2, labelRegion, USE.NAMES = F)
candidati_camera_dat$region <- 
  sapply(candidati_camera_dat$geo_lev_2, labelRegion, USE.NAMES = F)
liste_camera_dat$region <- 
  sapply(liste_camera_dat$geo_lev_2, labelRegion, USE.NAMES = F)

scrutini_senato_dat$region <- 
  sapply(scrutini_senato_dat$geo_lev_2, labelRegion, USE.NAMES = F)
candidati_senato_dat$region <- 
  sapply(candidati_senato_dat$geo_lev_2, labelRegion, USE.NAMES = F)
liste_senato_dat$region <- 
  sapply(liste_senato_dat$geo_lev_2, labelRegion, USE.NAMES = F)

regions <- unique(scrutini_camera_dat$region)

# Match entity names with geographic file
prepareNames <- function(x) {
  x <- tolower(x)
  x <- gsub("/(.*)", "", x)
  return(x)
}

## camera (cu = camera uninominale)
cu_unique <- 
  unique(rbind(scrutini_camera_dat[,c('region','geo_lev_4', 'geo_entity')],
               candidati_camera_dat[,c('region', 'geo_lev_4', 'geo_entity')],
               liste_camera_dat[,c('region', 'geo_lev_4','geo_entity')]))
cu_unique$metro <- duplicated(cu_unique[,c('region','geo_entity')]) |
  duplicated(cu_unique[,c('region','geo_entity')], fromLast = T)

cu_unique_metro <- cu_unique[cu_unique$metro,]
cu_unique <- cu_unique[!cu_unique$metro,]
cu_unique_metro$metro <- NULL
cu_unique$metro <- NULL

###
camera_matching_df <- data.frame()
library(stringdist)
for (this_region in regions) {
  print(this_region)
  this_dat <- cu_unique[cu_unique$region == this_region,]
  this_geo <- camera_sp@data[camera_sp@data$region == this_region,]
  this_geo$minint_cod <- as.character(this_geo$minint_cod)
  this_geo$istat_nam <- as.character(this_geo$istat_nam)
  this_geo$scu2017_cod <- as.character(this_geo$cu2017_cod)
  
  # String match 1
  this_dat$istat_nam <- 
    this_geo$istat_nam[match(prepareNames(this_dat$geo_entity), 
                             prepareNames(this_geo$istat_nam))]
  
  # String dist match 2
  this_dat_missing <- this_dat[is.na(this_dat$istat_nam),]
  if(nrow(this_dat_missing)>0) {
    this_geo_missing <- this_geo[!prepareNames(this_geo$istat_nam) %in% 
                                   prepareNames(this_dat$istat_nam),]
    this_dat <- this_dat[!is.na(this_dat$istat_nam),]
    for (i in 1:nrow(this_dat_missing)) {
      these_dists <- stringdist(prepareNames(this_dat_missing$geo_entity[i]), 
                                prepareNames(this_geo_missing$istat_nam))
      this_min <- min(these_dists)
      if (is.infinite(this_min)) stop("INFINITE")
      if (sum(this_min %in% these_dists) > 1) stop("MULTIPLE MATCHES!")
      this_dat_missing$istat_nam[i] <- 
        this_geo_missing$istat_nam[these_dists %in% this_min]
      this_geo_missing <- this_geo_missing[!these_dists %in% this_min,]
    }
    
    this_dat <- rbind(this_dat, this_dat_missing)
  }
  this_dat <- merge(this_dat, this_geo[,c('minint_cod',"cu2017_cod","istat_nam")],
                    by = "istat_nam")
  this_dat$cu2017_cod <- as.character(this_dat$cu2017_cod)
  camera_matching_df <- rbind(camera_matching_df, this_dat)
}

cu_unique_metro$istat_nam <- NA
cu_unique_metro$minint_cod <- NA
cu_unique_metro$cu2017_cod <- NA
cu_unique_metro$cu2017_nam <- NA

for (this_region in regions) {
  print(this_region)
  this_dat <- cu_unique_metro[cu_unique_metro$region == this_region,]
  if(nrow(this_dat) == 0) next
  # this_dat$istat_nam <- NA
  # this_dat$minint_cod <- NA
  # this_dat$cu2017_cod <- NA
  this_geo <- camera_sp@data[prepareNames(camera_sp@data$istat_nam) %in% 
                               prepareNames(this_dat$geo_entity),]
  this_geo$minint_cod <- as.character(this_geo$minint_cod)
  this_geo$istat_nam <- as.character(this_geo$istat_nam)
  this_geo$scu2017_cod <- as.character(this_geo$cu2017_cod)
  this_geo$cu2017_nam <- as.character(this_geo$cu2017_nam)
  if(nrow(this_geo)!=nrow(this_dat)) stop("DIFFERENT NROW!!")
  for (i in 1:nrow(this_dat)) {
    these_dists <- stringdist(prepareNames(this_dat$geo_lev_4[i]), 
                              prepareNames(this_geo$cu2017_nam))
    this_min <- min(these_dists)
    if (is.infinite(this_min)) stop("INFINITE")
    if (sum(this_min %in% these_dists) > 1) stop("MULTIPLE MATCHES!")
    which_i <- which(cu_unique_metro$geo_lev_4 == this_dat$geo_lev_4[i])
    cu_unique_metro$istat_nam[which_i] <- 
      this_geo$istat_nam[these_dists %in% this_min]
    cu_unique_metro$minint_cod[which_i] <-  
      this_geo$minint_cod[these_dists %in% this_min]
    cu_unique_metro$cu2017_cod[which_i] <-  
      this_geo$cu2017_cod[these_dists %in% this_min]
    cu_unique_metro$cu2017_nam[which_i] <-
      this_geo$cu2017_nam[these_dists %in% this_min]
  }
}
### Check
### View(cu_unique_metro[,c('geo_lev_4','cu2017_nam')])
### Manual corrections
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '04 - GENOVA - UNITA URBANISTICA SAN FRUTTUOSO'] <- "scrutiniCI10210340250"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '08 - MILANO AREA STATISTICA 117'] <- "scrutiniCI03310491450"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '11 - MILANO AREA STATISTICA 74'] <- "scrutiniCI03320491450"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '12 - MILANO AREA STATISTICA 84'] <- "scrutiniCI03330491450"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '13 - MILANO AREA STATISTICA 105'] <- "scrutiniCI03340491450"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '14 - MILANO AREA STATISTICA 144'] <- "scrutiniCI03350491450"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '01 TORINO - ZONA STATISTICA 16'] <- "scrutiniCI01110812620"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '02 TORINO - ZONA STATISTICA 38'] <- "scrutiniCI01120812620"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '03 TORINO - ZONA STATISTICA 48'] <- "scrutiniCI01130812620"
cu_unique_metro$minint_cod[cu_unique_metro$geo_lev_4 == '04 TORINO - ZONA STATISTICA 61'] <- "scrutiniCI01140812620"

camera_matching_df <- rbind(camera_matching_df, 
                            cu_unique_metro[,colnames(camera_matching_df)])

vars <- c('region', 'geo_lev_4', 'geo_entity')
scrutini_camera_dat <- 
  merge(scrutini_camera_dat, 
        camera_matching_df[,c(vars, 'istat_nam', 'minint_cod')], 
        by = vars)
scrutini_camera_dat <- 
  scrutini_camera_dat[,c("election", "date", "geo_lev_1",
                         "geo_lev_2", "geo_lev_3", "geo_lev_4", "geo_entity",
                         "registered_voters", "effective_voters",
                         "blank_votes", "invalid_votes",
                         "istat_nam", "minint_cod")]
candidati_camera_dat <- 
  merge(candidati_camera_dat, 
        camera_matching_df[,c(vars, 'istat_nam', 'minint_cod')], 
        by = vars)
candidati_camera_dat <- 
  candidati_camera_dat[,c("election", "date", "geo_lev_1",
                          "geo_lev_2", "geo_lev_3", "geo_lev_4", "geo_entity",
                          "candidate", "candidate_votes",
                          "coalition", "coalition_wd_id", 
                          "istat_nam", "minint_cod")]
liste_camera_dat <- 
  merge(liste_camera_dat, 
        camera_matching_df[,c(vars, 'istat_nam', 'minint_cod')], 
        by = vars)
liste_camera_dat <- 
  liste_camera_dat[,c("election", "date", "geo_lev_1",
                      "geo_lev_2", "geo_lev_3", "geo_lev_4", "geo_entity",
                      "party", "party_votes", "candidate", 
                      "party_wd_id", "coalition", "coalition_wd_id",
                      "istat_nam", "minint_cod")]

## Test
# View(camera_sp@data[!camera_sp@data$minint_cod %in% candidati_camera_dat$minint_cod,])

# Case of missing candidate == "CANDIDATO NON PRESENTE"

liste_camera_dat$party_wd_id[grepl("noentity", liste_camera_dat$party_wd_id)] <- NA
liste_camera_dat$coalition_wd_id[grepl("noentity", liste_camera_dat$coalition_wd_id)] <- NA
candidati_camera_dat$coalition_wd_id[grepl("noentity", candidati_camera_dat$coalition_wd_id)] <- NA

# Transformation functions
partyWidePerc <- function(liste_df) {
  library(dplyr)
  library(reshape2)
  res <- liste_df %>%
    group_by(minint_cod) %>%
    mutate(assigned_votes = sum(party_votes)) %>%
    group_by(party, add=TRUE) %>%
    summarize(perc = party_votes / assigned_votes)
  res <- dcast(res, minint_cod ~ party, value.var = 'perc')
  for (j in 2:ncol(res)) {
    res[[j]][is.na(res[[j]])] <- 0
  }
  return(res)
}

partyWideSum <- function(liste_df) {
  library(dplyr)
  library(reshape2)
  res <- liste_df %>%
    group_by(minint_cod, party) %>%
    summarize(party_votes = sum(party_votes))
  res <- dcast(res, minint_cod ~ party, value.var = 'party_votes')
  for (j in 2:ncol(res)) {
    res[[j]][is.na(res[[j]])] <- 0
  }
  return(res)
}

test <-
  candidati_camera_dat %>%
  group_by(minint_cod, coalition) %>%
  summarize(n = n())
dup <- test$minint_cod[test$n>1]
test <-
  candidati_camera_dat %>%
  group_by(minint_cod, coalition, geo_lev_4, candidate) %>%
  summarize(n = n())
# View(test[test$minint_cod %in% dup,])

coalitionWidePerc <- function(candidati_df) {
  library(dplyr)
  library(reshape2)
  res <- candidati_df %>%
    group_by(minint_cod) %>%
    mutate(assigned_votes = sum(candidate_votes)) %>%
    group_by(coalition, add=TRUE) %>%
    summarize(perc = candidate_votes / assigned_votes)
  res <- dcast(res, minint_cod ~ coalition, value.var = 'perc')
  for (j in 2:ncol(res)) {
    res[[j]][is.na(res[[j]])] <- 0
  }
  return(res)
}

candidatiWideSum <- function(candidati_df) {
  library(dplyr)
  library(reshape2)
  res <- candidati_df %>%
    group_by(minint_cod, coalition) %>%
    summarize(coalition_votes = sum(candidate_votes))
  res <- dcast(res, minint_cod ~ coalition, value.var = 'coalition_votes')
  for (j in 2:ncol(res)) {
    res[[j]][is.na(res[[j]])] <- 0
  }
  return(res)
}

liste_camera_dat_perc <- partyWidePerc(liste_camera_dat)
liste_camera_dat_sum <- partyWideSum(liste_camera_dat)

coalizione_camera_dat_perc <- candidatiWidePerc(candidati_camera_dat)
coalizione_camera_dat_sum <- candidatiWideSum(candidati_camera_dat)

write.csv(liste_camera_dat, file = 'open_csv_20180304_camera_party_count.csv', row.names = FALSE)
write.csv(liste_camera_dat_perc, file = 'open_csv_20180304_camera_party_perc_wide.csv', row.names = FALSE)
write.csv(liste_camera_dat_sum, file = 'open_csv_20180304_camera_party_sum_wide.csv', row.names = FALSE)
write.csv(scrutini_camera_dat, file = 'open_csv_20180304_camera_geo_count.csv', row.names = FALSE)
write.csv(candidati_camera_dat, file = 'open_csv_20180304_camera_candidate_count.csv', row.names = FALSE)
write.csv(coalizione_camera_dat_perc, file = 'open_csv_20180304_camera_coalition_perc_wide.csv', row.names = FALSE)
write.csv(coalizione_camera_dat_sum, file = 'open_csv_20180304_camera_coalition_sum_wide.csv', row.names = FALSE)


## senato (su = senato uninominale)
su_unique <- 
  unique(rbind(scrutini_senato_dat[,c('region','geo_lev_4', 'geo_entity')],
               candidati_senato_dat[,c('region', 'geo_lev_4', 'geo_entity')],
               liste_senato_dat[,c('region', 'geo_lev_4','geo_entity')]))
su_unique$metro <- duplicated(su_unique[,c('region','geo_entity')]) |
  duplicated(su_unique[,c('region','geo_entity')], fromLast = T)

su_unique_metro <- su_unique[su_unique$metro,]
su_unique <- su_unique[!su_unique$metro,]
su_unique_metro$metro <- NULL
su_unique$metro <- NULL

###
senato_matching_df <- data.frame()
library(stringdist)
for (this_region in regions) {
  print(this_region)
  this_dat <- su_unique[su_unique$region == this_region,]
  this_geo <- senato_sp@data[senato_sp@data$region == this_region,]
  this_geo$minint_cod <- as.character(this_geo$minint_cod)
  this_geo$istat_nam <- as.character(this_geo$istat_nam)
  this_geo$su2017_cod <- as.character(this_geo$su2017_cod)
  
  # String match 1
  this_dat$istat_nam <- 
    this_geo$istat_nam[match(prepareNames(this_dat$geo_entity), 
                             prepareNames(this_geo$istat_nam))]
  
  # String dist match 2
  this_dat_missing <- this_dat[is.na(this_dat$istat_nam),]
  if(nrow(this_dat_missing)>0) {
    this_geo_missing <- this_geo[!prepareNames(this_geo$istat_nam) %in% 
                                   prepareNames(this_dat$istat_nam),]
    this_dat <- this_dat[!is.na(this_dat$istat_nam),]
    for (i in 1:nrow(this_dat_missing)) {
      these_dists <- stringdist(prepareNames(this_dat_missing$geo_entity[i]), 
                                prepareNames(this_geo_missing$istat_nam))
      this_min <- min(these_dists)
      if (is.infinite(this_min)) stop("INFINITE")
      if (sum(this_min %in% these_dists) > 1) stop("MULTIPLE MATCHES!")
      this_dat_missing$istat_nam[i] <- 
        this_geo_missing$istat_nam[these_dists %in% this_min]
      this_geo_missing <- this_geo_missing[!these_dists %in% this_min,]
    }
    
    this_dat <- rbind(this_dat, this_dat_missing)
  }
  this_dat <- merge(this_dat, this_geo[,c('minint_cod',"su2017_cod","istat_nam")],
                    by = "istat_nam")
  this_dat$su2017_cod <- as.character(this_dat$su2017_cod)
  senato_matching_df <- rbind(senato_matching_df, this_dat)
}

su_unique_metro$istat_nam <- NA
su_unique_metro$minint_cod <- NA
su_unique_metro$su2017_cod <- NA
su_unique_metro$su2017_nam <- NA

for (this_region in regions) {
  print(this_region)
  this_dat <- su_unique_metro[su_unique_metro$region == this_region,]
  if(nrow(this_dat) == 0) next
  # this_dat$istat_nam <- NA
  # this_dat$minint_cod <- NA
  # this_dat$su2017_cod <- NA
  this_geo <- senato_sp@data[prepareNames(senato_sp@data$istat_nam) %in% 
                               prepareNames(this_dat$geo_entity),]
  this_geo$minint_cod <- as.character(this_geo$minint_cod)
  this_geo$istat_nam <- as.character(this_geo$istat_nam)
  this_geo$ssu2017_cod <- as.character(this_geo$su2017_cod)
  this_geo$su2017_nam <- as.character(this_geo$su2017_nam)
  if(nrow(this_geo)!=nrow(this_dat)) stop("DIFFERENT NROW!!")
  for (i in 1:nrow(this_dat)) {
    these_dists <- stringdist(prepareNames(this_dat$geo_lev_4[i]), 
                              prepareNames(this_geo$su2017_nam))
    this_min <- min(these_dists)
    if (is.infinite(this_min)) stop("INFINITE")
    if (sum(this_min %in% these_dists) > 1) stop("MULTIPLE MATCHES!")
    which_i <- which(su_unique_metro$geo_lev_4 == this_dat$geo_lev_4[i])
    su_unique_metro$istat_nam[which_i] <- 
      this_geo$istat_nam[these_dists %in% this_min]
    su_unique_metro$minint_cod[which_i] <-  
      this_geo$minint_cod[these_dists %in% this_min]
    su_unique_metro$su2017_cod[which_i] <-  
      this_geo$su2017_cod[these_dists %in% this_min]
    su_unique_metro$su2017_nam[which_i] <-
      this_geo$su2017_nam[these_dists %in% this_min]
  }
}
### Check
### View(su_unique_metro[,c('geo_lev_4','su2017_nam')])
### Manual corrections
su_unique_metro$minint_cod[su_unique_metro$geo_lev_4 == '04 - TORINO - ZONA STATISTICA 61'] <- "scrutiniSI01140812620"
su_unique_metro$minint_cod[su_unique_metro$geo_lev_4 == '01 - MILANO - AREA STATISTICA 84'] <- "scrutiniSI03410491450"
su_unique_metro$minint_cod[su_unique_metro$geo_lev_4 == '02 - MILANO - AREA STATISTICA 74'] <- "scrutiniSI03420491450"

senato_matching_df <- rbind(senato_matching_df, 
                            su_unique_metro[,colnames(senato_matching_df)])

vars <- c('region', 'geo_lev_4', 'geo_entity')
scrutini_senato_dat <- 
  merge(scrutini_senato_dat, 
        senato_matching_df[,c(vars, 'istat_nam', 'minint_cod')], 
        by = vars)
scrutini_senato_dat <- 
  scrutini_senato_dat[,c("election", "date", "geo_lev_1",
                         "geo_lev_2", "geo_lev_3", "geo_lev_4", "geo_entity",
                         "registered_voters", "effective_voters",
                         "blank_votes", "invalid_votes",
                         "istat_nam", "minint_cod")]
candidati_senato_dat <- 
  merge(candidati_senato_dat, 
        senato_matching_df[,c(vars, 'istat_nam', 'minint_cod')], 
        by = vars)
candidati_senato_dat <- 
  candidati_senato_dat[,c("election", "date", "geo_lev_1",
                          "geo_lev_2", "geo_lev_3", "geo_lev_4", "geo_entity",
                          "candidate", "candidate_votes",
                          "coalition", "coalition_wd_id", 
                          "istat_nam", "minint_cod")]
liste_senato_dat <- 
  merge(liste_senato_dat, 
        senato_matching_df[,c(vars, 'istat_nam', 'minint_cod')], 
        by = vars)
liste_senato_dat <- 
  liste_senato_dat[,c("election", "date", "geo_lev_1",
                      "geo_lev_2", "geo_lev_3", "geo_lev_4", "geo_entity",
                      "party", "party_votes", "candidate", 
                      "party_wd_id", "coalition", "coalition_wd_id",
                      "istat_nam", "minint_cod")]

## Test
# View(senato_sp@data[!senato_sp@data$minint_cod %in% candidati_senato_dat$minint_cod,])

# Case of missing candidate == "CANDIDATO NON PRESENTE"

liste_senato_dat$party_wd_id[grepl("noentity", liste_senato_dat$party_wd_id)] <- NA
liste_senato_dat$coalition_wd_id[grepl("noentity", liste_senato_dat$coalition_wd_id)] <- NA
candidati_senato_dat$coalition_wd_id[grepl("noentity", candidati_senato_dat$coalition_wd_id)] <- NA

test <-
  candidati_senato_dat %>%
  group_by(minint_cod, coalition) %>%
  summarize(n = n())
dup <- test$minint_cod[test$n>1]
test <-
  candidati_senato_dat %>%
  group_by(minint_cod, coalition, geo_lev_4, candidate) %>%
  summarize(n = n())
# View(test[test$minint_cod %in% dup,])


liste_senato_dat_perc <- partyWidePerc(liste_senato_dat)
liste_senato_dat_sum <- partyWideSum(liste_senato_dat)

coalizione_senato_dat_perc <- candidatiWidePerc(candidati_senato_dat)
coalizione_senato_dat_sum <- candidatiWideSum(candidati_senato_dat)

write.csv(liste_senato_dat, file = 'open_csv_20180304_senato_party_count.csv', row.names = FALSE)
write.csv(liste_senato_dat_perc, file = 'open_csv_20180304_senato_party_perc_wide.csv', row.names = FALSE)
write.csv(liste_senato_dat_sum, file = 'open_csv_20180304_senato_party_sum_wide.csv', row.names = FALSE)
write.csv(scrutini_senato_dat, file = 'open_csv_20180304_senato_geo_count.csv', row.names = FALSE)
write.csv(candidati_senato_dat, file = 'open_csv_20180304_senato_candidate_count.csv', row.names = FALSE)
write.csv(coalizione_senato_dat_perc, file = 'open_csv_20180304_senato_coalition_perc_wide.csv', row.names = FALSE)
write.csv(coalizione_senato_dat_sum, file = 'open_csv_20180304_senato_coalition_sum_wide.csv', row.names = FALSE)
