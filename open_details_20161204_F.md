\[Italian constitutional referendum 4 December 2016
================
Francesco Bailo
24 October 2018

The details on variables and decriptive statistics on the results of the
2016 constitutional referendum at the comune level.

# Dataset

  - `open_csv_20161204_F.csv`

## Variable description

### Character variables

  - `type` is `SCRUTINI`.
  - `election` is `Referendum`.
  - `date` in format `%Y-%m-%d`.
  - `geo_lev_1` is `ITALIA` for all records.
  - `geo_lev_2` is the region name as set by the original data provider.
  - `geo_lev_3` is the province name as set by the original data
    provider (there are 106 provinces).
  - `geo_entity` name of the geographical entity described by the
    observation as set by the original data provider.

### Numerical variables

  - `yes_votes` the sum of “yes” votes.
  - `no_votes` the sum of votes “no” votes.
  - `registered_voters` the sum of voters registered for the election
    and entitled to vote in the geographical entity.
  - `effective_voters` the sum of voters actually showing up to vote in
    the geographical entity.
  - `blank_votes`
  - `invalid_votes` the sum of non-assigned votes (it includes
    `blank_votes`) in the geographical entity.

### Variables linking to other resources

  - `istat_cod` is the name used by ISTAT in the geographic file
    `open_shp_20161204_F`.

## Variable summary

### open\_csv\_20161204\_F

| yes\_votes |  no\_votes | registered\_voters | effective\_voters | blank\_votes | invalid\_votes |
| ---------: | ---------: | -----------------: | ----------------: | -----------: | -------------: |
| 12,708,172 | 19,026,617 |         46,720,943 |        31,997,916 |       74,120 |        263,127 |

| yes\_votes | no\_votes | registered\_voters | effective\_voters | blank\_votes | invalid\_votes |
| ---------: | --------: | :----------------- | ----------------: | -----------: | -------------: |
|      40.04 |     59.96 | NA                 |             68.49 |         0.23 |           0.82 |
