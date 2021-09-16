General elections 9 April 2006 (Chamber of Deputy)
================
Francesco Bailo
16 September 2o21

The details on variables and decriptive statistics on the results of the
2006 elections for both the Chamber and the Senate (formally two
different elections with different electorates).

# Count datasets

Count data for geographic entitiy (municipal level or lower) is provided
in the following files:

-   `open_csv_20060409_camera_geo_count.csv` ([download from
    Dataverse](https://dataverse.harvard.edu/file.xhtml?fileId=5152871&version=13.1));
-   `open_csv_20060409_camera_party_count.csv` ([download from
    Dataverse](https://dataverse.harvard.edu/file.xhtml?fileId=5152872&version=13.1)).

The raw tabular files are also available from
[here](https://dataverse.harvard.edu/file.xhtml?fileId=5152870&version=13.1).

For the Chamber of Deputies (`camera`), 2 open datasets are provided:

-   `party_count` with information on votes received by parties (“liste”
    in Italian).
-   `geo_count` with general electoral count information on the
    geographic entity.

## Variable description

### Character variables

-   `election` set to `Camera`.
-   `date` in format `%Y-%m-%d`.
-   `geo_lev_1` to `geo_lev_2` the label as set by the original data
    provider for the the electoral boundaries (from larger to smaller)
    of the geographical entity described by the observation.
-   `geo_entity` name of the geographical entity described by the
    observation as set by the original data provider.
-   `party` name of the list as set by the original data provider.
-   `istat_cod` code of `geo_entity` as set by [Italy’s National
    Institute of Statistics
    (Istat)](https://en.wikipedia.org/wiki/National_Institute_of_Statistics_(Italy))
    (also `PRO_COM_T`). Use this to join with the geographic files
    [raw\_shp\_20060409](https://dataverse.harvard.edu/file.xhtml?fileId=5152869&version=13.1).)

### Numerical variables

-   `party_votes` the sum of votes received by a party in the
    geographical entity.
-   `tot_party_votes` the sum of votes received by all parties in the
    geographical entity.
-   `registered_voters` the sum of voters registered for the election
    and entitled to vote in the geographical entity.
-   `registered_male_voters`
-   `effective_voters` the sum of voters actually casting a vote in the
    election
-   `effective_male_voters`
-   `blank_votes`
-   `invalid_votes` the sum ofnon-assigned votes (it includes
    `blank_votes`) in the geographical entity.

## Variable summary

### camera\_party\_count

| party\_votes |   % |
|-------------:|----:|
|   38,231,107 | 100 |

| party                         | party\_votes |     % |
|:------------------------------|-------------:|------:|
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

### camera\_geo\_count

| registered\_voters | registered\_male\_voters | effective\_voters | % (effective) | effective\_male\_voters | tot\_party\_votes | blank\_votes | % (valid votes) |
|-------------------:|-------------------------:|------------------:|--------------:|------------------------:|------------------:|-------------:|----------------:|
|         47,098,181 |               22,563,632 |        39,382,430 |         83.62 |              19,329,321 |        38,231,107 |      441,791 |           97.08 |
