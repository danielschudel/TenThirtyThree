---
title: DLA/DoD 1033 Analysis
header-includes:
- \usepackage{fancyhdr}
- \pagestyle{fancy}
- \fancyhead[LO,RE]{Aspen Partition and Image Data}
- \fancyfoot[CE,CO]{\thepage}
- \fancyfoot[LE,RO]{Extreme Networks Confidential}
---





# Data Sources

The [DLA’s](http://www.dispositionservices.dla.mil/) Law Enforcement Support Office (LESO) transfers excess Department of Defense
property to federal, state, and local law enforcement agencies within the United States and its Territories

Details of transfers since 1950 have been documented on this webpage.

* [http://www.dispositionservices.dla.mil/EFOIA-Privacy/Pages/ereadingroom.aspx#1033](http://www.dispositionservices.dla.mil/EFOIA-Privacy/Pages/ereadingroom.aspx#1033)

The following files available above are used in this analysis:

|File Name                |Description                   |URL                                                                    |
|-------------------------|------------------------------|-----------------------------------------------------------------------|
|tacticalatLEAAL-LA.xls|DLA/DoD 1033 Alaska - Louisiana|http://www.dispositionservices.dla.mil/EFOIA-Privacy/Documents/tacticalatLEAAL-LA.xls|
|tacticalatLEAMA-WYandTerr.xls|DLA/DoD 1033 Massachusetts - Wyoming and territories|http://www.dispositionservices.dla.mil/EFOIA-Privacy/Documents/tacticalatLEAMA-WYandTerr.xls|

# Data Transformations

All data transformations can be inspected on this project's [GitHub](http://www.github.com) project page - [https://github.com/danielschudel/TenThirtyThree/](https://github.com/danielschudel/TenThirtyThree/). The two files ```analyze.R``` and ```encodeCounties.R``` are of particular interest.

# NC

## Triangle Counties

Agencies within the following counties are included:

* Chatham
* Durham
* Orange
* Wake

### Data Summaries

<!-- html table generated in R 3.1.2 by xtable 1.7-4 package -->
<!-- Sun Dec  7 21:42:40 2014 -->
<table border=1>
<tr> <th> agencyName </th> <th> shipYear </th> <th> itemName </th> <th> totalItems </th> <th> totalValue </th>  </tr>
  <tr> <td align="right"> cary police </td> <td> 2007 </td> <td> rifle </td> <td> 27 </td> <td align="right"> $13,473 </td> </tr>
  <tr> <td align="right"> chapel hill police </td> <td> 2012 </td> <td> truck,armored </td> <td> 1 </td> <td align="right"> $65,070 </td> </tr>
  <tr> <td align="right"> clayton police </td> <td> 2006 </td> <td> rifle </td> <td> 2 </td> <td align="right"> $276 </td> </tr>
  <tr> <td align="right"> durham co. sheriff </td> <td> 2007 </td> <td> rifle </td> <td> 28 </td> <td align="right"> $13,972 </td> </tr>
  <tr> <td align="right"> durham co. sheriff </td> <td> 2008 </td> <td> rifle </td> <td> 4 </td> <td align="right"> $1,996 </td> </tr>
  <tr> <td align="right"> durham police </td> <td> 1993 </td> <td> rifle </td> <td> 6 </td> <td align="right"> $828 </td> </tr>
  <tr> <td align="right"> durham police </td> <td> 1995 </td> <td> night vision sight </td> <td> 1 </td> <td align="right"> $2,350 </td> </tr>
  <tr> <td align="right"> durham police </td> <td> 2006 </td> <td> rifle </td> <td> 64 </td> <td align="right"> $26,882 </td> </tr>
  <tr> <td align="right"> garner police </td> <td> 2004 </td> <td> night vision sight </td> <td> 1 </td> <td align="right"> $5,029 </td> </tr>
  <tr> <td align="right"> garner police </td> <td> 2006 </td> <td> rifle </td> <td> 10 </td> <td align="right"> $4,990 </td> </tr>
  <tr> <td align="right"> hillsborough police </td> <td> 1993 </td> <td> rifle </td> <td> 3 </td> <td align="right"> $414 </td> </tr>
  <tr> <td align="right"> hillsborough police </td> <td> 1998 </td> <td> night vision sight </td> <td> 1 </td> <td align="right"> $5,201 </td> </tr>
  <tr> <td align="right"> holly springs police </td> <td> 2010 </td> <td> rifle </td> <td> 8 </td> <td align="right"> $960 </td> </tr>
  <tr> <td align="right"> mebane police </td> <td> 2006 </td> <td> rifle </td> <td> 4 </td> <td align="right"> $1,996 </td> </tr>
  <tr> <td align="right"> orange co. sheriff </td> <td> 1995 </td> <td> night vision sight </td> <td> 1 </td> <td align="right"> $2,350 </td> </tr>
  <tr> <td align="right"> orange co. sheriff </td> <td> 2003 </td> <td> combat/assault/tactical vehicle </td> <td> 1 </td> <td align="right"> $157,600 </td> </tr>
  <tr> <td align="right"> pittsboro police </td> <td> 1993 </td> <td> rifle </td> <td> 1 </td> <td align="right"> $138 </td> </tr>
  <tr> <td align="right"> pittsboro police </td> <td> 2008 </td> <td> pistol </td> <td> 5 </td> <td align="right"> $294 </td> </tr>
  <tr> <td align="right"> pittsboro police </td> <td> 2013 </td> <td> rifle </td> <td> 1 </td> <td align="right"> $138 </td> </tr>
  <tr> <td align="right"> pittsboro police </td> <td> 2013 </td> <td> shotgun,12 gage,riot type </td> <td> 2 </td> <td align="right"> $144 </td> </tr>
  <tr> <td align="right"> RDU Police </td> <td> 2010 </td> <td> launcher,grenade </td> <td> 2 </td> <td align="right"> $1,440 </td> </tr>
  <tr> <td align="right"> rolesville police </td> <td> 2008 </td> <td> pistol </td> <td> 1 </td> <td align="right"> $59 </td> </tr>
  <tr> <td align="right"> rolesville police </td> <td> 2008 </td> <td> rifle </td> <td> 3 </td> <td align="right"> $775 </td> </tr>
  <tr> <td align="right"> wake co. sheriff </td> <td> 2013 </td> <td> swab,small arms cleaning </td> <td> 1 </td> <td align="right"> $7 </td> </tr>
  <tr> <td align="right"> wake forest police </td> <td> 2006 </td> <td> rifle </td> <td> 1 </td> <td align="right"> $1,278 </td> </tr>
  <tr> <td align="right"> wake forest police </td> <td> 2008 </td> <td> rifle </td> <td> 2 </td> <td align="right"> $276 </td> </tr>
  <tr> <td align="right"> wake forest police </td> <td> 2010 </td> <td> rifle </td> <td> 1 </td> <td align="right"> $138 </td> </tr>
  <tr> <td align="right"> wake forest police </td> <td> 2012 </td> <td> truck,armored </td> <td> 1 </td> <td align="right"> $65,070 </td> </tr>
  <tr> <td align="right"> wakemed campus police </td> <td> 1993 </td> <td> rifle </td> <td> 1 </td> <td align="right"> $138 </td> </tr>
  <tr> <td align="right"> zebulon police </td> <td> 1993 </td> <td> rifle </td> <td> 3 </td> <td align="right"> $414 </td> </tr>
  <tr> <td align="right"> zebulon police </td> <td> 1995 </td> <td> night vision sight </td> <td> 1 </td> <td align="right"> $2,350 </td> </tr>
   </table>

#### Specific Notes

* 2003 transfer of combat/assault/tactical vehicle to the Orange County Sheriff is coded as having an acquisition value of $0.01 (US Dollars).
    * This is assumed to be a clerical mistake. Five other counties received similar items with a significantly higher recorded value. The mean of those values
      is substituted for the recorded $0.01.
    * It is possible that the transferred item did have a near zero value.

### Total Value of Items Transferred

![](figure/unnamed-chunk-4-1.png) 

### Itemization of Items Transferred

![](figure/unnamed-chunk-5-1.png) 

# Copying

This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.

Follow these links for licensing and re-use details:

* [http://creativecommons.org/licenses/by-sa/4.0/](http://creativecommons.org/licenses/by-sa/4.0/)
* [http://creativecommons.org/licenses/by-sa/4.0/legalcode](http://creativecommons.org/licenses/by-sa/4.0/legalcode)

# Adapting

This work is available on [GitHub](http://github.com) at the following URL:

* [https://github.com/danielschudel/TenThirtyThree/](https://github.com/danielschudel/TenThirtyThree/)
