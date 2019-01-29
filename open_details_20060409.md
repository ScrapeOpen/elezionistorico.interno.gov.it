General elections 9 April 2006 (Chamber of Deputy and Senate of the
Republic)
================
Francesco Bailo
29 January 2019

The details on variables and decriptive statistics on the results of the
2006 elections for both the Chamber and the Senate (formally two
different elections with different electorates).

# Count datasets

Count data for geographic entitiy (municipal level or lower) is provided
in the following files:

  - `open_csv_20060409_senato_geo_count.csv`;
  - `open_csv_20060409_camera_geo_count.csv`;
  - `open_csv_20060409_senato_party_count.csv`;
  - `open_csv_20060409_camera_party_count.csv`.

For each election, Chamber of Deputies (`camera`) and the Senate of the
Republic (`senato`), 2 open datasets are provided:

  - `party_count` with information on votes received by parties.
  - `geo_count` with general electoral count information on the
    geographic entity.

## Variable description

### Character variables

  - `election` either `Senato` or `Camera`.
  - `date` in format `%Y-%m-%d`.
  - `geo_lev_1` to `geo_lev_2` the label as set by the original data
    provider for the the electoral boundaries (from larger to smaller)
    of the geographical entity described by the observation.
  - `geo_entity` name of the geographical entity described by the
    observation as set by the original data provider.

### Numerical variables

  - `party_votes` the sum of votes received by a party in the
    geographical entity.
  - `candidate_votes` the sum of votes received by a candidate (that is,
    also by a coalition) in the geographical entity.
  - `registered_voters` the sum of voters registered for the election
    and entitled to vote in the geographical entity.
  - `blank_votes`
  - `invalid_votes` the sum ofnon-assigned votes (it includes
    `blank_votes`) in the geographical entity.

## Variable summary

### camera\_party\_count

| party\_votes |   % |
| -----------: | --: |
|   38,231,107 | 100 |

| party                         | party\_votes |     % |
| :---------------------------- | -----------: | ----: |
| L’ULIVO                       |   11,929,536 | 31.20 |
| FORZA ITALIA                  |    9,046,869 | 23.66 |
| ALLEANZA NAZIONALE            |    4,707,060 | 12.31 |
| UNIONE DI CENTRO              |    2,582,417 |  6.75 |
| RIFONDAZIONE COMUNISTA        |    2,229,858 |  5.83 |
| LEGA NORD                     |    1,748,034 |  4.57 |
| LA ROSA NEL PUGNO             |      990,443 |  2.59 |
| COMUNISTI ITALIANI            |      884,677 |  2.31 |
| DI PIETRO ITALIA DEI VALORI   |      877,092 |  2.29 |
| FEDERAZIONE DEI VERDI         |      783,931 |  2.05 |
| U.D.EUR POPOLARI              |      534,440 |  1.40 |
| PARTITO PENSIONATI            |      334,936 |  0.88 |
| DEM.CRIST.-NUOVO PSI          |      285,493 |  0.75 |
| ALTERNATIVA SOCIALE MUSSOLINI |      257,025 |  0.67 |
| FIAMMA TRICOLORE              |      231,612 |  0.61 |
| SVP                           |      182,703 |  0.48 |
| I SOCIALISTI                  |      115,090 |  0.30 |
| PROGETTO NORDEST              |       92,079 |  0.24 |
| LISTA CONSUMATORI             |       73,687 |  0.19 |
| NO EURO                       |       58,720 |  0.15 |
| ALLEANZA LOMBARDA AUTONOMIA   |       44,580 |  0.12 |
| AUT.LIB. DEMOCRATIE           |       34,168 |  0.09 |
| PENSIONATI UNITI              |       27,818 |  0.07 |
| VALLEE D’AOSTE                |       24,119 |  0.06 |
| LIGA FRONTE VENETO            |       22,010 |  0.06 |
| AMBIENTA-LISTA                |       17,372 |  0.05 |
| DIE FREIHEITLICHEN            |       17,167 |  0.04 |
| TERZO POLO                    |       16,234 |  0.04 |
| FI-AN                         |       13,374 |  0.03 |
| P.LIBERALE ITALIANO           |       12,308 |  0.03 |
| IRS                           |       11,649 |  0.03 |
| SARDIGNA NATZIONE             |       11,000 |  0.03 |
| S.O.S. ITALIA                 |        6,956 |  0.02 |
| SOLIDARIETA’                  |        5,878 |  0.02 |
| MOV.DEM.SIC-NOI SIC.          |        5,176 |  0.01 |
| PER IL SUD                    |        5,130 |  0.01 |
| MOVIMENTO TRIVENETO           |        4,518 |  0.01 |
| DIMENSIONE CHRISTIANA         |        2,447 |  0.01 |
| LEGA NORD V.D’AOSTE           |        1,566 |  0.00 |
| DESTRA NAZIONALE              |        1,088 |  0.00 |
| LEGA SUD                      |          847 |  0.00 |

### senato\_party\_count

| party\_votes |   % |
| -----------: | --: |
|   34,808,754 | 100 |

| party                         | party\_votes |     % |
| :---------------------------- | -----------: | ----: |
| FORZA ITALIA                  |    8,202,505 | 23.56 |
| DEMOCRATICI SINISTRA          |    5,977,433 | 17.17 |
| ALLEANZA NAZIONALE            |    4,234,913 | 12.17 |
| DL.LA MARGHERITA              |    3,664,830 | 10.53 |
| RIFONDAZIONE COMUNISTA        |    2,518,580 |  7.24 |
| UNIONE DI CENTRO              |    2,311,522 |  6.64 |
| LEGA NORD                     |    1,530,303 |  4.40 |
| INSIEME CON L’UNIONE          |    1,423,012 |  4.09 |
| DI PIETRO ITALIA DEI VALORI   |      986,145 |  2.83 |
| LA ROSA NEL PUGNO             |      851,724 |  2.45 |
| U.D.EUR POPOLARI              |      477,198 |  1.37 |
| PARTITO PENSIONATI            |      357,731 |  1.03 |
| FIAMMA TRICOLORE              |      219,621 |  0.63 |
| ALTERNATIVA SOCIALE MUSSOLINI |      215,295 |  0.62 |
| L’UNIONE SVP                  |      198,153 |  0.57 |
| DEM.CRIST.-NUOVO PSI          |      190,714 |  0.55 |
| CASA DELLE LIBERTA’           |      175,137 |  0.50 |
| I SOCIALISTI                  |      126,327 |  0.36 |
| SVP                           |      117,500 |  0.34 |
| PROGETTO NORDEST              |       93,159 |  0.27 |
| ALLEANZA LOMBARDA AUTONOMIA   |       90,943 |  0.26 |
| LISTA CONSUMATORI             |       72,089 |  0.21 |
| PENSIONATI UNITI              |       61,928 |  0.18 |
| L’ULIVO                       |       59,498 |  0.17 |
| PSDI                          |       57,392 |  0.16 |
| REPUBBLICANI EUROPEI          |       51,020 |  0.15 |
| PRI                           |       45,151 |  0.13 |
| AMBIENTA-LISTA                |       36,583 |  0.11 |
| ALLEANZA SICILIANA            |       36,088 |  0.10 |
| NUOVA SICILIA                 |       33,458 |  0.10 |
| AUT.LIB. DEMOCRATIE           |       32,554 |  0.09 |
| NO EURO                       |       30,515 |  0.09 |
| L’UNIONE                      |       27,629 |  0.08 |
| P.COM.MARX-LEN.               |       26,008 |  0.07 |
| VALLEE D’AOSTE                |       23,574 |  0.07 |
| LIGA FRONTE VENETO            |       23,209 |  0.07 |
| PATTO PER LA SICILIA          |       20,856 |  0.06 |
| PENSIONI E LAVORO             |       19,765 |  0.06 |
| DIE FREIHEITLICHEN            |       16,746 |  0.05 |
| PS D’AZ.                      |       16,735 |  0.05 |
| P.LIBERALE ITALIANO           |       15,757 |  0.05 |
| TERZO POLO                    |       13,352 |  0.04 |
| FORZA ROMA                    |       13,320 |  0.04 |
| FI-AN                         |       11,505 |  0.03 |
| IRS                           |       10,693 |  0.03 |
| PER IL SUD                    |        9,992 |  0.03 |
| PATTO CRIST.ESTESO            |        9,741 |  0.03 |
| SARDIGNA NATZIONE             |        8,409 |  0.02 |
| RIFORMATORI LIBERALI          |        7,701 |  0.02 |
| MOVIMENTO TRIVENETO           |        7,433 |  0.02 |
| UNIONE POP. AUT.              |        7,327 |  0.02 |
| MOV.DEM.SIC-NOI SIC.          |        6,576 |  0.02 |
| SOLIDARIETA’                  |        5,424 |  0.02 |
| DEMOCRAZIA CRISTIANI UNITI    |        5,399 |  0.02 |
| S.O.S. ITALIA                 |        4,963 |  0.01 |
| PARTITO DONNE D’EUROPA        |        4,213 |  0.01 |
| MOV.IDEA SOC. RAUTI           |        3,030 |  0.01 |
| LEGA SUD                      |        2,486 |  0.01 |
| DIMENSIONE CHRISTIANA         |        2,435 |  0.01 |
| ITALIA MODERATA               |        2,082 |  0.01 |
| UN.FEDERALISTA MERIDIONALE    |        1,800 |  0.01 |
| LEGA NORD V.D’AOSTE           |        1,573 |  0.00 |

### camera\_geo\_count

| registered\_voters | effective\_voters | % (effective) | blank\_votes | invalid\_votes | % (invalid) |
| -----------------: | ----------------: | ------------: | -----------: | -------------: | ----------: |
|         47,098,181 |        39,382,430 |         83.62 |      441,791 |      1,151,323 |        2.92 |

### senato\_geo\_count

| registered\_voters | effective\_voters | % (effective) | blank\_votes | invalid\_votes | % (invalid) |
| -----------------: | ----------------: | ------------: | -----------: | -------------: | ----------: |
|         43,012,783 |        35,943,615 |         83.56 |      481,348 |      1,134,861 |        3.16 |
