setwd('~/public_git/ScrapeOpen/elezionistorico.interno.gov.it') # Change this!
options(warn=2) # Warnings into errors!

dir <- "~/Downloads/raw_csv_20060409/" # Change this
files <- list.files(dir)
files <- unique(files)

# Check files
library(stringr)
filename_head <- str_extract(files, "^[A-Z]+-[A-Z][a-z]+")
table(filename_head)
## Missing
files_camera <- files[grepl("Camera", files)]
files_camera_scrutini <- gsub("SCRUTINI-", "", files_camera[grepl("SCRUTINI", files_camera)])
files_camera_liste <- gsub("LISTE-", "", files_camera[grepl("LISTE", files_camera)])
files_camera_scrutini[!files_camera_scrutini %in% files_camera_liste]

files_senato <- files[grepl("Senato", files)]
files_senato_scrutini <- gsub("SCRUTINI-", "", files_senato[grepl("SCRUTINI", files_senato)])
files_senato_liste <- gsub("LISTE-", "", files_senato[grepl("LISTE", files_senato)])
files_senato_scrutini[! files_senato_scrutini %in% files_senato_liste]

files <- list.files(dir, full.names = F)


file_path_regex <-
  "^.*(SCRUTINI|LISTE)-(Senato|Camera)-09_04_2006-(VALLE_D'AOSTA_e_TRENTINO-ALTO_ADIGE|ITALIA_\\(escl\\._Valle_d'Aosta\\))-"

splitFileName <- function(x) {
  require(stringr)
  x <- gsub("FRIULI-VENEZIA", "FRIULI~VENEZIA", x)
  x <- gsub("EMILIA-ROMAGNA", "EMILIA~ROMAGNA", x)
  x <- gsub("TRENTINO-ALTO", "TRENTINO~ALTO", x)
  x <- gsub("Trentino-Alto", "Trentino~Alto", x)
  this_split <- strsplit(gsub("\\.csv", "", x), "-")[[1]]
  this_type <- this_split[1]
  this_what <- this_split[2]
  this_date <- as.character(as.Date(this_split[3], "%d_%m_%Y"))
  this_where_1 <-  this_split[5]
  this_where_2 <- this_split[6]
  return(list(type = this_type,
              election = this_what,
              date = this_date,
              geo_lev_1 = gsub("([A-Z])~([A-Z])", "\\1-\\2", this_where_1),
              geo_lev_2 = gsub("([A-Z])~([A-Z])", "\\1-\\2", this_where_2)))
}

makeDF <- function(lst, dat) {
  details <-
    data.frame(matrix(unlist(lst), nrow=1, byrow=T,
                      dimnames = list(NULL, names(lst))))
  details <-
    do.call("rbind", replicate(nrow(dat), details, simplify = FALSE))
  return(cbind(details, dat))
}

read_dat <- function(f) {
  print(f)
  require(zoo)
  file_details <- splitFileName(f)
  this_dat <- read.csv(paste0(dir, f), sep = ";", row.names = NULL, colClasses = 'character')
  if (file_details[['type']] == 'SCRUTINI') {
    this_dat <- this_dat[,1:5]
    colnames(this_dat) <-
      c("Ente", "Numero.elettori", "Numero.votanti", "Schede.bianche",
        "Schede.non.valide")
    this_dat$Numero.elettori <- as.numeric(gsub("\\.", "", this_dat$Numero.elettori))
    this_dat$Numero.votanti <- as.numeric(gsub("\\.", "", this_dat$Numero.votanti))
    this_dat$Schede.bianche <- as.numeric(gsub("\\.", "", this_dat$Schede.bianche))
    this_dat$Schede.non.valide <- as.numeric(gsub("\\.", "", this_dat$Schede.non.valide))
    return(makeDF(file_details,
                   data.frame(geo_entity = this_dat$Ente,
                              registered_voters = this_dat$Numero.elettori,
                              effective_voters = this_dat$Numero.votanti,
                              blank_votes = this_dat$Schede.bianche,
                              invalid_votes = this_dat$Schede.non.valide,
                              stringsAsFactors = F)))
  } else if (file_details[['type']] == 'LISTE') {

    if (file_details$geo_lev_2 == "Comune") {
      file_details$geo_lev_2 <- file_details$geo_lev_1
      this_dat <- this_dat[,1:4]
      colnames(this_dat) <- c("Ente","Candidato","Voti","Liste.Gruppi")
      this_dat <- this_dat[,c("Ente", "Candidato", "Liste.Gruppi", "Voti")]
      }

    if (!"Candidato" %in% names(this_dat)) {
      colnames(this_dat) <- c("Ente", "Liste.Gruppi", "Voti", "Candidato", "X")
      this_dat$X <- NULL
      this_dat$Candidato <- NA
    } else {
      this_dat <- this_dat[,1:4]
      colnames(this_dat) <- c("Ente", "Candidato", "Liste.Gruppi", "Voti")
      this_dat$Candidato <- as.character(this_dat$Candidato)
      this_dat$Candidato[this_dat$Candidato == ""] <- NA
      this_dat$Candidato <- na.locf(this_dat$Candidato)
    }
    this_dat$Voti <- as.numeric(gsub("\\.", "", this_dat$Voti))
    return(makeDF(file_details,
                   data.frame(geo_entity = this_dat$Ente,
                              candidate = this_dat$Candidato,
                              party_votes = this_dat$Voti,
                              party = this_dat$Liste.Gruppi,
                              stringsAsFactors = F)))
  }
}

require(data.table)
scrutini_dat <- rbindlist(lapply(files[grepl("SCRUTINI", files)], read_dat))
liste_dat <- rbindlist(lapply(files[grepl("LISTE",files)], read_dat))

# Encoding
Encoding(scrutini_dat$geo_entity) <- "UTF-8"
scrutini_dat$geo_entity <-
  gsub("\xc0", "A'", scrutini_dat$geo_entity)
scrutini_dat$geo_entity <-
  gsub("\xc8", "E'", scrutini_dat$geo_entity)
scrutini_dat$geo_entity <-
  gsub("\xd2", "O'", scrutini_dat$geo_entity)
scrutini_dat$geo_entity <-
  gsub("\xd9", "U'", scrutini_dat$geo_entity)

Encoding(liste_dat$geo_entity) <- "UTF-8"
liste_dat$geo_entity <-
  gsub("\xc0", "A'", liste_dat$geo_entity)
liste_dat$geo_entity <-
  gsub("\xc8", "E'", liste_dat$geo_entity)
liste_dat$geo_entity <-
  gsub("\xd2", "O'", liste_dat$geo_entity)
liste_dat$geo_entity <-
  gsub("\xd9", "U'", liste_dat$geo_entity)

# Trim
for (var in colnames(liste_dat)) {
  if(is.numeric(liste_dat[[var]])) next
  liste_dat[[var]] <- str_trim(liste_dat[[var]])
}
for (var in colnames(scrutini_dat)) {
  if(is.numeric(scrutini_dat[[var]])) next
  scrutini_dat[[var]] <- str_trim(scrutini_dat[[var]])
}

write.csv(scrutini_dat[scrutini_dat$election == 'Senato'],
          file = "open_csv_20060409_senato_geo_count.csv",
          row.names = F)
write.csv(scrutini_dat[scrutini_dat$election == 'Camera'],
          file = "open_csv_20060409_camera_geo_count.csv",
          row.names = F)
write.csv(liste_dat[liste_dat$election == 'Senato'],
          file = "open_csv_20060409_senato_party_count.csv",
          row.names = F)
write.csv(liste_dat[liste_dat$election == 'Camera'],
          file = "open_csv_20060409_camera_party_count.csv",
          row.names = F)




