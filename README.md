Getting Started With NFL Highlights Tracking Data
================

*This is meant to be a very simple introduction to working with the
tracking data housed in this repo. For a more in-depth guide on working
with the NFL’s tracking data, check out [Mike Lopez’s
notebook](https://www.kaggle.com/statsbymichaellopez/nfl-tracking-wrangling-voronoi-and-sonars)
from the most recent Big Data Bowl.*

-----

### Intro

Tracking data has been billed as “the future of sports analytics,” but
it’s notoriously difficult to both acquire and use. This repo was
created to help alleviate those issues; it contains tracking data from
the NFL’s Next Gen Stats (NGS) Highlights for 2017-2019 seasons, as well
as a few Rscripts with helper functions to make it easier to work with
the data.

In this walk-through, we will:

  - import an NGS Highlight play’s tracking data  
  - plot the frames from a play (with some extras)
  - animate a play

-----

### Setting Things Up

Before getting started with the data, we need to install and load a few
libraries, as well as the Rscripts containing helper functions.

``` r
# * install packages ----
install.packages("devtools", "tidyverse")
devtools::install_github('thomasp85/ggforce')
devtools::install_github('thomasp85/gganimate')
```

``` r
# * load packages ----
library(devtools)
library(dplyr)
library(gganimate)
library(ggforce)
library(ggplot2)
library(readr)
```

``` r
# * load helper functions ----
source_url("https://raw.githubusercontent.com/asonty/ngs_highlights/master/utils/scripts/data_utils.R")
source_url("https://raw.githubusercontent.com/asonty/ngs_highlights/master/utils/scripts/plot_utils.R")
```

-----

### Importing the Data

#### Listing the Highlights

We can use the `fetch_highlights_list()` function to grab a list of the
NGS Highlights in this repo, and by using the `team_` and `season_`
arguments, we can filter the list down.

Lamar Jackson had some ridiculous plays during his MVP season, so let’s
look at the Ravens’ highlights from 2019:

``` r
highlights <- fetch_highlights_list(team_ = "BAL", season_ = 2019)
```

<!--html_preserve-->

<div id="wnovgbvvkz" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

playKey

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

playDesc

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

team

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

season

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

week

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

gameId

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

playId

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_right">

237

</td>

<td class="gt_row gt_left">

(13:56) (Shotgun) L.Jackson pass deep middle to W.Snead for 33 yards,
TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_right">

2019090803

</td>

<td class="gt_row gt_right">

1082

</td>

</tr>

<tr>

<td class="gt_row gt_right">

238

</td>

<td class="gt_row gt_left">

(4:28) (Shotgun) L.Jackson pass deep middle to M.Brown for 83 yards,
TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_right">

2019090803

</td>

<td class="gt_row gt_right">

683

</td>

</tr>

<tr>

<td class="gt_row gt_right">

239

</td>

<td class="gt_row gt_left">

(8:12) (Shotgun) L.Jackson pass deep right to M.Andrews for 27 yards,
TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

2

</td>

<td class="gt_row gt_right">

2019091500

</td>

<td class="gt_row gt_right">

343

</td>

</tr>

<tr>

<td class="gt_row gt_right">

240

</td>

<td class="gt_row gt_left">

(1:24) (Shotgun) J.Hurst reported in as eligible. L.Jackson right tackle
for 8 yards, TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

7

</td>

<td class="gt_row gt_right">

2019102010

</td>

<td class="gt_row gt_right">

2997

</td>

</tr>

<tr>

<td class="gt_row gt_right">

241

</td>

<td class="gt_row gt_left">

(5:11) (Shotgun) R.Wilson pass short right intended for J.Brown
INTERCEPTED by M.Peters at BLT 33. M.Peters for 67 yards, TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

7

</td>

<td class="gt_row gt_right">

2019102010

</td>

<td class="gt_row gt_right">

1654

</td>

</tr>

<tr>

<td class="gt_row gt_right">

242

</td>

<td class="gt_row gt_left">

(8:18) (Shotgun) L.Jackson left end for 47 yards, TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

2019111001

</td>

<td class="gt_row gt_right">

2257

</td>

</tr>

<tr>

<td class="gt_row gt_right">

243

</td>

<td class="gt_row gt_left">

(11:49) (Shotgun) L.Jackson right end to BLT 48 for 3 yards. Lateral to
R.Griffin III pushed ob at CIN 43 for 9 yards (J.Bates III).

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

2019111001

</td>

<td class="gt_row gt_right">

1000

</td>

</tr>

<tr>

<td class="gt_row gt_right">

244

</td>

<td class="gt_row gt_left">

(4:12) (Shotgun) G.Edwards left guard for 63 yards, TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

11

</td>

<td class="gt_row gt_right">

2019111700

</td>

<td class="gt_row gt_right">

4243

</td>

</tr>

<tr>

<td class="gt_row gt_right">

245

</td>

<td class="gt_row gt_left">

(9:11) (Shotgun) L.Jackson left tackle to HST 20 for 39 yards (J.Reid).
HST-L.Johnson was injured during the play.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

11

</td>

<td class="gt_row gt_right">

2019111700

</td>

<td class="gt_row gt_right">

2795

</td>

</tr>

<tr>

<td class="gt_row gt_right">

246

</td>

<td class="gt_row gt_left">

(9:54) (Shotgun) L.Jackson pass short middle to W.Snead IV for 4 yards,
TOUCHDOWN. Caught at goal line, crossing to right.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

14

</td>

<td class="gt_row gt_right">

2019120801

</td>

<td class="gt_row gt_right">

3526

</td>

</tr>

<tr>

<td class="gt_row gt_right">

247

</td>

<td class="gt_row gt_left">

(13:44) (Shotgun) L.Jackson pass deep left to H.Hurst for 61 yards,
TOUCHDOWN \[J.Hughes\]. Flag pattern, caught at BUF 41.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

14

</td>

<td class="gt_row gt_right">

2019120801

</td>

<td class="gt_row gt_right">

2271

</td>

</tr>

<tr>

<td class="gt_row gt_right">

248

</td>

<td class="gt_row gt_left">

(1:04) (Shotgun) L.Jackson pass deep left to S.Roberts for 33 yards,
TOUCHDOWN. Lamar Jackson’s 4th TD pass of game and 32nd of season.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

15

</td>

<td class="gt_row gt_right">

2019121200

</td>

<td class="gt_row gt_right">

2839

</td>

</tr>

<tr>

<td class="gt_row gt_right">

249

</td>

<td class="gt_row gt_left">

(5:14) (Shotgun) L.Jackson pass deep middle to M.Brown for 24 yards,
TOUCHDOWN.

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

15

</td>

<td class="gt_row gt_right">

2019121200

</td>

<td class="gt_row gt_right">

2486

</td>

</tr>

<tr>

<td class="gt_row gt_right">

250

</td>

<td class="gt_row gt_left">

(13:40) (Shotgun) L.Jackson right guard pushed ob at TEN 42 for 27 yards
(W.Woodyard).

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

19

</td>

<td class="gt_row gt_right">

2020011101

</td>

<td class="gt_row gt_right">

3181

</td>

</tr>

<tr>

<td class="gt_row gt_right">

251

</td>

<td class="gt_row gt_left">

(12:16) (Shotgun) L.Jackson scrambles left guard to TEN 27 for 30 yards
(L.Ryan).

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

19

</td>

<td class="gt_row gt_right">

2020011101

</td>

<td class="gt_row gt_right">

2230

</td>

</tr>

<tr>

<td class="gt_row gt_right">

252

</td>

<td class="gt_row gt_left">

(:18) (Shotgun) L.Jackson pass deep right to M.Brown to TEN 04 for 38
yards (A.Hooker).

</td>

<td class="gt_row gt_left">

BAL

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_right">

19

</td>

<td class="gt_row gt_right">

2020011101

</td>

<td class="gt_row gt_right">

1899

</td>

</tr>

</tbody>

</table>

</div>

<!--/html_preserve-->

#### Importing the Tracking Data

The first column in the table (`playKey`) is a unique identifier for
each play in the dataset, and is used by the `fetch_play_data()`
function to grab the tracking data for a play. Let’s take a look at
Lamar Jackson’s 47-yard touchdown run. The `playKey` for that play is
`242`, so we’ll provide that to `fetch_play_data()`.

``` r
play_data <- fetch_play_data(playKey_ = 242)
```

<!--html_preserve-->

<div id="xtevqgtgkt" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

gameId

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

playId

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

playType

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

season

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

seasonType

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

week

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

preSnapHomeScore

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

preSnapVisitorScore

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

playDirection

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

quarter

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">

gameClock

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

down

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

yardsToGo

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

yardline

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

yardlineSide

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

yardlineNumber

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

absoluteYardlineNumber

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

possessionFlag

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

homeTeamFlag

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

teamAbbr

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

frame

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

displayName

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

esbId

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

gsisId

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

jerseyNumber

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

nflId

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

position

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

positionGroup

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

time

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

x

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

y

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

s

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

o

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

dir

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

event

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

playDescription

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_right">

2019111001

</td>

<td class="gt_row gt_right">

2257

</td>

<td class="gt_row gt_left">

play\_type\_rush

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_left">

REG

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

28

</td>

<td class="gt_row gt_left">

left

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

08:18:00

</td>

<td class="gt_row gt_right">

2

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_left">

CIN 47

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

47

</td>

<td class="gt_row gt_right">

57

</td>

<td class="gt_row gt_right">

0

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

0

</td>

<td class="gt_row gt_left">

Geno Atkins

</td>

<td class="gt_row gt_left">

ATK216644

</td>

<td class="gt_row gt_left">

00-0027720

</td>

<td class="gt_row gt_right">

97

</td>

<td class="gt_row gt_right">

496762

</td>

<td class="gt_row gt_left">

DT

</td>

<td class="gt_row gt_left">

DL

</td>

<td class="gt_row gt_left">

2019-11-10 19:46:19

</td>

<td class="gt_row gt_right">

54.74

</td>

<td class="gt_row gt_right">

29.83

</td>

<td class="gt_row gt_right">

0.01

</td>

<td class="gt_row gt_right">

80.80

</td>

<td class="gt_row gt_right">

95.59

</td>

<td class="gt_row gt_left">

huddle\_start\_offense

</td>

<td class="gt_row gt_left">

(8:18) (Shotgun) L.Jackson left end for 47 yards, TOUCHDOWN.

</td>

</tr>

<tr>

<td class="gt_row gt_right">

2019111001

</td>

<td class="gt_row gt_right">

2257

</td>

<td class="gt_row gt_left">

play\_type\_rush

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_left">

REG

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

28

</td>

<td class="gt_row gt_left">

left

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

08:18:00

</td>

<td class="gt_row gt_right">

2

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_left">

CIN 47

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

47

</td>

<td class="gt_row gt_right">

57

</td>

<td class="gt_row gt_right">

0

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_left">

Geno Atkins

</td>

<td class="gt_row gt_left">

ATK216644

</td>

<td class="gt_row gt_left">

00-0027720

</td>

<td class="gt_row gt_right">

97

</td>

<td class="gt_row gt_right">

496762

</td>

<td class="gt_row gt_left">

DT

</td>

<td class="gt_row gt_left">

DL

</td>

<td class="gt_row gt_left">

2019-11-10 19:46:19

</td>

<td class="gt_row gt_right">

54.74

</td>

<td class="gt_row gt_right">

29.83

</td>

<td class="gt_row gt_right">

0.01

</td>

<td class="gt_row gt_right">

80.80

</td>

<td class="gt_row gt_right">

98.23

</td>

<td class="gt_row gt_left">

NA

</td>

<td class="gt_row gt_left">

(8:18) (Shotgun) L.Jackson left end for 47 yards, TOUCHDOWN.

</td>

</tr>

<tr>

<td class="gt_row gt_right">

2019111001

</td>

<td class="gt_row gt_right">

2257

</td>

<td class="gt_row gt_left">

play\_type\_rush

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_left">

REG

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

28

</td>

<td class="gt_row gt_left">

left

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

08:18:00

</td>

<td class="gt_row gt_right">

2

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_left">

CIN 47

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

47

</td>

<td class="gt_row gt_right">

57

</td>

<td class="gt_row gt_right">

0

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

2

</td>

<td class="gt_row gt_left">

Geno Atkins

</td>

<td class="gt_row gt_left">

ATK216644

</td>

<td class="gt_row gt_left">

00-0027720

</td>

<td class="gt_row gt_right">

97

</td>

<td class="gt_row gt_right">

496762

</td>

<td class="gt_row gt_left">

DT

</td>

<td class="gt_row gt_left">

DL

</td>

<td class="gt_row gt_left">

2019-11-10 19:46:20

</td>

<td class="gt_row gt_right">

54.74

</td>

<td class="gt_row gt_right">

29.83

</td>

<td class="gt_row gt_right">

0.01

</td>

<td class="gt_row gt_right">

81.44

</td>

<td class="gt_row gt_right">

94.54

</td>

<td class="gt_row gt_left">

NA

</td>

<td class="gt_row gt_left">

(8:18) (Shotgun) L.Jackson left end for 47 yards, TOUCHDOWN.

</td>

</tr>

<tr>

<td class="gt_row gt_right">

2019111001

</td>

<td class="gt_row gt_right">

2257

</td>

<td class="gt_row gt_left">

play\_type\_rush

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_left">

REG

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

28

</td>

<td class="gt_row gt_left">

left

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

08:18:00

</td>

<td class="gt_row gt_right">

2

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_left">

CIN 47

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

47

</td>

<td class="gt_row gt_right">

57

</td>

<td class="gt_row gt_right">

0

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_left">

Geno Atkins

</td>

<td class="gt_row gt_left">

ATK216644

</td>

<td class="gt_row gt_left">

00-0027720

</td>

<td class="gt_row gt_right">

97

</td>

<td class="gt_row gt_right">

496762

</td>

<td class="gt_row gt_left">

DT

</td>

<td class="gt_row gt_left">

DL

</td>

<td class="gt_row gt_left">

2019-11-10 19:46:20

</td>

<td class="gt_row gt_right">

54.74

</td>

<td class="gt_row gt_right">

29.84

</td>

<td class="gt_row gt_right">

0.01

</td>

<td class="gt_row gt_right">

81.44

</td>

<td class="gt_row gt_right">

86.27

</td>

<td class="gt_row gt_left">

NA

</td>

<td class="gt_row gt_left">

(8:18) (Shotgun) L.Jackson left end for 47 yards, TOUCHDOWN.

</td>

</tr>

<tr>

<td class="gt_row gt_right">

2019111001

</td>

<td class="gt_row gt_right">

2257

</td>

<td class="gt_row gt_left">

play\_type\_rush

</td>

<td class="gt_row gt_right">

2019

</td>

<td class="gt_row gt_left">

REG

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

10

</td>

<td class="gt_row gt_right">

28

</td>

<td class="gt_row gt_left">

left

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_center">

08:18:00

</td>

<td class="gt_row gt_right">

2

</td>

<td class="gt_row gt_right">

3

</td>

<td class="gt_row gt_left">

CIN 47

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

47

</td>

<td class="gt_row gt_right">

57

</td>

<td class="gt_row gt_right">

0

</td>

<td class="gt_row gt_right">

1

</td>

<td class="gt_row gt_left">

CIN

</td>

<td class="gt_row gt_right">

4

</td>

<td class="gt_row gt_left">

Geno Atkins

</td>

<td class="gt_row gt_left">

ATK216644

</td>

<td class="gt_row gt_left">

00-0027720

</td>

<td class="gt_row gt_right">

97

</td>

<td class="gt_row gt_right">

496762

</td>

<td class="gt_row gt_left">

DT

</td>

<td class="gt_row gt_left">

DL

</td>

<td class="gt_row gt_left">

2019-11-10 19:46:20

</td>

<td class="gt_row gt_right">

54.74

</td>

<td class="gt_row gt_right">

29.84

</td>

<td class="gt_row gt_right">

0.01

</td>

<td class="gt_row gt_right">

81.44

</td>

<td class="gt_row gt_right">

84.09

</td>

<td class="gt_row gt_left">

NA

</td>

<td class="gt_row gt_left">

(8:18) (Shotgun) L.Jackson left end for 47 yards, TOUCHDOWN.

</td>

</tr>

</tbody>

</table>

</div>

<!--/html_preserve-->

-----

### Visualizing Plays

In my opinion, the most fun way to get started with tracking data is
through visualizations. To that end, we can use the `plot_play_frame()`
function to plot any given frame in a play.

It’s important to note that the tracking data contains the entire
runtime of the play, including all of the dead time prior to the line
being set, and in some cases even the team celebrations after a
touchdown is scored. So let’s first find the ‘frame interval’ of the
play:

``` r
first_frame <- play_data %>%
  filter(event == "line_set") %>% 
  distinct(frame) %>% 
  slice_max(frame) %>% 
  pull()

final_frame <- play_data %>% 
  filter(event == "tackle" | event == "touchdown" | event == "out_of_bounds") %>% 
  distinct(frame) %>% 
  slice_max(frame) %>% 
  pull()

first_frame
```

    ## [1] 113

``` r
final_frame
```

    ## [1] 270

#### Basic Play Frame Plot

Now that we’ve got a better idea of the interval in which the play takes
place, let’s visualize it.

``` r
plot_play_frame(play_data_ = play_data, frame_ = 180)
```

![](README_files/figure-gfm/plot_frame-1.png)<!-- -->

#### Play Frame Plot + Velocity Vectors

`plot_play_frame()` also has a `velocities_` parameter, which, when set
to `TRUE`, adds the players’ velocity vectors to the plot.

``` r
plot_play_frame(play_data_ = play_data, frame_ = 200, velocities_ = T)
```

![](README_files/figure-gfm/plot_frame_vel-1.png)<!-- -->

#### Play Frame Plot + Voronoi Tessellation

In past Big Data Bowls, some of the top submissions borrowed a concept
from soccer called “pitch control.” Pitch control models aim to quantify
the areas of the field that players/teams control; an example of a basic
pitch control model is Voronoi tessellation. We can use the `voronoi_`
argument to add a Voronoi layer to play frame
plots:

``` r
plot_play_frame(play_data_ = play_data, frame_ = 220, velocities_ = F, voronoi_ = T)
```

![](README_files/figure-gfm/plot_frame_vor-1.png)<!-- -->

The final in-built function we can use is `plot_play_sequence()`, which
plots `n_` number of frames between a `first_frame_` and `final_frame_`
at evenly spaced
intervals:

``` r
plot_play_sequence(play_data, first_frame_ = first_frame, final_frame_ = final_frame, n_=6, velocities_ = T, voronoi_ = T)
```

<img src="README_files/figure-gfm/plot_play_seq-1.png" style="display: block; margin: auto;" />

-----

### Animating a Play

The next step in visualizing a play is animation. Rather than just
animating the data as-is, let’s transform it a bit. In our animation,
we’re going to highlight the fastest player on each team at every
frame of the play.

#### Data Manipulation

First, we’ll reduce the dataset, split it up into player and ball data,
and grab some details.

``` r
# * reduce dataset ----
reduced_play_data <- play_data %>% filter(frame >= first_frame, frame <= final_frame+10)

# * get play details ----
play_desc <- reduced_play_data$playDescription %>% .[1]
play_dir <- reduced_play_data$playDirection %>% .[1]
yards_togo <- reduced_play_data$yardsToGo %>% .[1]
los <- reduced_play_data$absoluteYardlineNumber %>% .[1]
togo_line <- if(play_dir=="left") los-yards_togo else los+yards_togo

# * separate player and ball tracking data ----
player_data <- reduced_play_data %>% 
  select(frame, homeTeamFlag, teamAbbr, displayName, gsisId, jerseyNumber, position, positionGroup,
         x, y, s, o, dir, event) %>% 
  filter(displayName != "ball")
ball_data <- reduced_play_data %>% 
  select(frame, homeTeamFlag, teamAbbr, displayName, jerseyNumber, position, positionGroup,
         x, y, s, o, dir, event) %>% 
  filter(displayName == "ball")

# * get team details ----
h_team <- reduced_play_data %>% filter(homeTeamFlag == 1) %>% distinct(teamAbbr) %>% pull()
a_team <- reduced_play_data %>% filter(homeTeamFlag == 0) %>% distinct(teamAbbr) %>% pull()
#  call helper function to get team colors
team_colors <- fetch_team_colors(h_team_ = h_team, a_team_ = a_team)
h_team_color1 <- team_colors[1]
h_team_color2 <- team_colors[2]
a_team_color1 <- team_colors[3]
a_team_color2 <- team_colors[4]
```

Next, we’ll compute the x and y component’s of each player’s velocity.
Note that the `dir` variable specifies the direction of the player’s
movement; it is `0` degrees when the player is facing ‘up’ on the field
(towards the far sideline) and increases in the clockwise direction.

``` r
# * compute velocity components ----
#  velocity angle in radians
player_data$dir_rad <- player_data$dir * pi / 180

#  velocity components
player_data$v_x <- sin(player_data$dir_rad) * player_data$s
player_data$v_y <- cos(player_data$dir_rad) * player_data$s
```

Finally, we’ll identify the fastest players on each team in every frame,
and merge that information with our `player_data`:

``` r
#  there are assuredly better ways to do this

# * identify the fastest player from each team at each frame ----
fastest_players <- player_data %>% # filter out ball-tracking data
  group_by(frame, teamAbbr) %>% # group by frame and team
  arrange(s) %>% top_n(s, n=1) %>% # take only the players with the highest speed on each team at every frame
  mutate(isFastestFlag = 1) %>% # create new flag identifying fastest players
  ungroup() %>% 
  select(frame, gsisId, isFastestFlag) %>%  # reduce dataset to the columns needed for joining and the new flag
  arrange(frame) # sort by frame

player_data <- player_data %>% 
  left_join(fastest_players, by = c("frame" = "frame", "gsisId" = "gsisId")) %>% # join on frame and gsisId
  mutate(isFastestFlag = case_when(is.na(isFastestFlag) ~ 0, TRUE ~ 1)) # replace NA values for isFastestFlag with 0
```

#### Animating the Play

Unfortunately, we can’t just use the `plot_play_frame()` function to
animate a play, so we’re going to peel back the function’s innards to
create our
animation.

``` r
play_frames <- plot_field() + # plot_field() is a helper function that returns a ggplot2 object of an NFL field
  # line of scrimmage
  annotate(
    "segment",
    x = los, xend = los, y = 0, yend = 160/3,
    colour = "#0d41e1"
  ) +
  # 1st down marker
  annotate(
    "segment",
    x = togo_line, xend = togo_line, y = 0, yend = 160/3,
    colour = "#f9c80e"
  ) +
  # away team velocities
  geom_segment(
    data = player_data %>% filter(teamAbbr == a_team),
    mapping = aes(x = x, y = y, xend = x + v_x, yend = y + v_y),
    colour = a_team_color1, size = 1, arrow = arrow(length = unit(0.01, "npc"))
  ) + 
  # home team velocities
  geom_segment(
    data = player_data %>% filter(teamAbbr == h_team),
    mapping = aes(x = x, y = y, xend = x + v_x, yend = y + v_y),
    colour = h_team_color1, size = 1, arrow = arrow(length = unit(0.01, "npc"))
  ) +
  # away team locations
  geom_point(
    data = player_data %>% filter(teamAbbr == a_team),
    mapping = aes(x = x, y = y),
    fill = "#ffffff", color = a_team_color2,
    shape = 21, alpha = 1, size = 6
  ) +
  # away team jersey numbers
  geom_text(
    data = player_data %>% filter(teamAbbr == a_team),
    mapping = aes(x = x, y = y, label = jerseyNumber),
    color = a_team_color1, size = 3.5, #family = "mono"
  ) +
  # home team locations
  geom_point(
    data = player_data %>% filter(teamAbbr == h_team),
    mapping = aes(x = x, y = y),
    fill = h_team_color1, color = h_team_color2,
    shape = 21, alpha = 1, size = 6
  ) +
  # home team jersey numbers
  geom_text(
    data = player_data %>% filter(teamAbbr == h_team),
    mapping = aes(x = x, y = y, label = jerseyNumber),
    color = h_team_color2, size = 3.5, #family = "mono"
  ) +
  # ball location
  geom_point(
    data = ball_data,
    mapping = aes(x = x, y = y),
    fill = "#935e38", color = "#d9d9d9",
    shape = 21, alpha = 1, size = 4
  ) +
  # highlight fastest players
  geom_point(
    data = player_data %>% filter(isFastestFlag == 1),
    mapping = aes(x = x, y = y),
    colour = "#e9ff70",
    alpha = 0.5, size = 8
  ) +
  # play description and always cite your data source!
  labs(
    title = play_desc,
    caption = "Source: NFL Next Gen Stats"
  ) + 
  # animation stuff
  transition_time(frame) +
  ease_aes('linear') +
  NULL

# ensure timing of play matches 10 frames-per-second (h/t NFL Football Ops)
play_length <- length(unique(player_data$frame))
play_anim <- animate(
  play_frames,
  fps = 10, 
  nframe = play_length,
  width = 850,
  height = 500,
  end_pause = 10
)
```

![](README_files/figure-gfm/play_anim_example.gif)
