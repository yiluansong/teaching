---
title: "Phenology sample data"
author: "Yiluan Song"
date: "2023-09-10"
output: html_document
---

<link href="{{< blogdown/postref >}}index_files/tabwid/tabwid.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/tabwid/tabwid.js"></script>
<link href="{{< blogdown/postref >}}index_files/tabwid/tabwid.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/tabwid/tabwid.js"></script>

Data prepared for Dr. Yang Chen’s class in STATS605 2023 Fall, also good for others interested in exploring phenology data.

Data files and code for generating them can be found in [this GitHub repo](https://github.com/yiluansong/phenology-sample-data).

This blog gives some first steps reading and visualizing the data.

<iframe style="height:500px;width:100%" src="https://docs.google.com/document/d/1X65JVcC2iEuRqwa0ZyO6vMCJWHNo9WdxdO8EEEW4-RA/edit?usp=sharing"></iframe>

## Meta data for trees

``` r
metadata <- read_csv("data/metadata.csv")

metadata %>%
  head() %>%
  flextable::regulartable() %>%
  flextable::autofit() %>%
  flextable::fit_to_width(8)
```

<div class="tabwid"><style>.cl-81eceae2{}.cl-81e4e0e0{font-family:'DejaVu Sans';font-size:8pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-81e7f730{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-81e7f73a{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-81e8103a{width:0.498in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81044{width:0.715in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81045{width:0.755in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e8104e{width:1.748in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e8104f{width:1.115in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81050{width:1.333in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81051{width:0.498in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81058{width:0.715in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81059{width:0.755in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e8105a{width:1.748in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81062{width:1.115in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81063{width:1.333in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81064{width:0.498in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81065{width:0.715in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e8106c{width:0.755in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e8106d{width:1.748in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e8106e{width:1.115in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-81e81076{width:1.333in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}</style><table data-quarto-disable-processing='true' class='cl-81eceae2'>

<caption style="display:table-caption;">
(#tab:unnamed-chunk-2)Part of the meta data for tagged trees.
</caption>

<thead><tr style="overflow-wrap:break-word;"><th class="cl-81e8103a"><p class="cl-81e7f730"><span class="cl-81e4e0e0">site</span></p></th><th class="cl-81e81044"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">site_lat</span></p></th><th class="cl-81e81045"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">site_lon</span></p></th><th class="cl-81e8104e"><p class="cl-81e7f730"><span class="cl-81e4e0e0">id</span></p></th><th class="cl-81e81044"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">lat</span></p></th><th class="cl-81e81045"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">lon</span></p></th><th class="cl-81e8104f"><p class="cl-81e7f730"><span class="cl-81e4e0e0">species</span></p></th><th class="cl-81e81050"><p class="cl-81e7f730"><span class="cl-81e4e0e0">growth_form</span></p></th></tr></thead><tbody><tr style="overflow-wrap:break-word;"><td class="cl-81e81051"><p class="cl-81e7f730"><span class="cl-81e4e0e0">HARV</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54278</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17213</span></p></td><td class="cl-81e8105a"><p class="cl-81e7f730"><span class="cl-81e4e0e0">NEON.PLA.D01.HARV.06016</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54368</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17330</span></p></td><td class="cl-81e81062"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Quercus rubra L.</span></p></td><td class="cl-81e81063"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Deciduous broadleaf</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-81e81051"><p class="cl-81e7f730"><span class="cl-81e4e0e0">HARV</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54278</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17213</span></p></td><td class="cl-81e8105a"><p class="cl-81e7f730"><span class="cl-81e4e0e0">NEON.PLA.D01.HARV.06046</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54186</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17096</span></p></td><td class="cl-81e81062"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Quercus rubra L.</span></p></td><td class="cl-81e81063"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Deciduous broadleaf</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-81e81051"><p class="cl-81e7f730"><span class="cl-81e4e0e0">HARV</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54278</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17213</span></p></td><td class="cl-81e8105a"><p class="cl-81e7f730"><span class="cl-81e4e0e0">NEON.PLA.D01.HARV.06034</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54310</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17097</span></p></td><td class="cl-81e81062"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Quercus rubra L.</span></p></td><td class="cl-81e81063"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Deciduous broadleaf</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-81e81051"><p class="cl-81e7f730"><span class="cl-81e4e0e0">HARV</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54278</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17213</span></p></td><td class="cl-81e8105a"><p class="cl-81e7f730"><span class="cl-81e4e0e0">NEON.PLA.D01.HARV.06041</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54225</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17102</span></p></td><td class="cl-81e81062"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Quercus rubra L.</span></p></td><td class="cl-81e81063"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Deciduous broadleaf</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-81e81051"><p class="cl-81e7f730"><span class="cl-81e4e0e0">HARV</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54278</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17213</span></p></td><td class="cl-81e8105a"><p class="cl-81e7f730"><span class="cl-81e4e0e0">NEON.PLA.D01.HARV.06039</span></p></td><td class="cl-81e81058"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54233</span></p></td><td class="cl-81e81059"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17089</span></p></td><td class="cl-81e81062"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Quercus rubra L.</span></p></td><td class="cl-81e81063"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Deciduous broadleaf</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-81e81064"><p class="cl-81e7f730"><span class="cl-81e4e0e0">HARV</span></p></td><td class="cl-81e81065"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54278</span></p></td><td class="cl-81e8106c"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17213</span></p></td><td class="cl-81e8106d"><p class="cl-81e7f730"><span class="cl-81e4e0e0">NEON.PLA.D01.HARV.06029</span></p></td><td class="cl-81e81065"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">42.54373</span></p></td><td class="cl-81e8106c"><p class="cl-81e7f73a"><span class="cl-81e4e0e0">-72.17132</span></p></td><td class="cl-81e8106e"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Quercus rubra L.</span></p></td><td class="cl-81e81076"><p class="cl-81e7f730"><span class="cl-81e4e0e0">Deciduous broadleaf</span></p></td></tr></tbody></table></div>

``` r
metadata %>%
  ggplot() +
  geom_point(aes(x = lon, y = lat, col = species)) +
  facet_wrap(. ~ site, scales = "free") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(col = "none") +
  labs(
    x = "Longitude",
    y = "Latitude"
  )
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" alt="Coordinates of tagged trees at two selected sites. Colors indicate species." width="672" />
<p class="caption">
<span id="fig:unnamed-chunk-3"></span>Figure 1: Coordinates of tagged trees at two selected sites. Colors indicate species.
</p>

</div>

## Discrete phenology data.

``` r
rnpn::npn_pheno_classes() %>%
  filter(id %in% 1:5) %>%
  select(id, name, description) %>%
  flextable::regulartable() %>%
  flextable::autofit() %>%
  flextable::fit_to_width(8)
```

<div class="tabwid"><style>.cl-8298bc3c{}.cl-8290e8a4{font-family:'DejaVu Sans';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-82947230{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-8294723a{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-829485b8{width:0.425in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485c2{width:2.301in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485cc{width:3.829in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485cd{width:0.425in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485d6{width:2.301in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485d7{width:3.829in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485e0{width:0.425in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485e1{width:2.301in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-829485e2{width:3.829in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}</style><table data-quarto-disable-processing='true' class='cl-8298bc3c'>

<caption style="display:table-caption;">
(#tab:unnamed-chunk-4)Definitions of five phenophases.
</caption>

<thead><tr style="overflow-wrap:break-word;"><th class="cl-829485b8"><p class="cl-82947230"><span class="cl-8290e8a4">id</span></p></th><th class="cl-829485c2"><p class="cl-8294723a"><span class="cl-8290e8a4">name</span></p></th><th class="cl-829485cc"><p class="cl-8294723a"><span class="cl-8290e8a4">description</span></p></th></tr></thead><tbody><tr style="overflow-wrap:break-word;"><td class="cl-829485cd"><p class="cl-82947230"><span class="cl-8290e8a4">1</span></p></td><td class="cl-829485d6"><p class="cl-8294723a"><span class="cl-8290e8a4">Initial shoot or leaf growth</span></p></td><td class="cl-829485d7"><p class="cl-8294723a"><span class="cl-8290e8a4">Initiation of seasonal vegetative growth</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-829485cd"><p class="cl-82947230"><span class="cl-8290e8a4">2</span></p></td><td class="cl-829485d6"><p class="cl-8294723a"><span class="cl-8290e8a4">Young leaves or needles</span></p></td><td class="cl-829485d7"><p class="cl-8294723a"><span class="cl-8290e8a4">Presence of foliage still in process of maturing</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-829485cd"><p class="cl-82947230"><span class="cl-8290e8a4">3</span></p></td><td class="cl-829485d6"><p class="cl-8294723a"><span class="cl-8290e8a4">Leaves or needles</span></p></td><td class="cl-829485d7"><p class="cl-8294723a"><span class="cl-8290e8a4">Presence of live foliage</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-829485cd"><p class="cl-82947230"><span class="cl-8290e8a4">4</span></p></td><td class="cl-829485d6"><p class="cl-8294723a"><span class="cl-8290e8a4">Colored leaves or needles</span></p></td><td class="cl-829485d7"><p class="cl-8294723a"><span class="cl-8290e8a4">Senescent coloring of foliage</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-829485e0"><p class="cl-82947230"><span class="cl-8290e8a4">5</span></p></td><td class="cl-829485e1"><p class="cl-8294723a"><span class="cl-8290e8a4">Falling leaves or needles</span></p></td><td class="cl-829485e2"><p class="cl-8294723a"><span class="cl-8290e8a4">Dropping of foliage</span></p></td></tr></tbody></table></div>

``` r
dat_discrete <- read_csv("data/discrete.csv")

dat_discrete %>%
  filter(status == "yes") %>%
  mutate(doy = date %>% lubridate::mdy() %>% lubridate::yday()) %>%
  arrange(phenophase_code) %>%
  mutate(phenophase = factor(phenophase, levels = unique(phenophase))) %>%
  ggplot() +
  geom_segment(aes(x = doy, xend = doy, y = 0, yend = 1), alpha = 0.01, col = "dark green") +
  facet_wrap(. ~ phenophase * site, ncol = 2) +
  theme_classic() +
  labs(
    x = "Day of year",
    y = ""
  ) +
  theme(axis.title.y = element_blank())
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" alt="Time of Yes observation of phenophase status." width="672" />
<p class="caption">
<span id="fig:unnamed-chunk-5"></span>Figure 2: Time of Yes observation of phenophase status.
</p>

</div>

``` r
dat_discrete <- read_csv("data/discrete.csv")

dat_discrete %>%
  filter(!is.na(intensity)) %>%
  mutate(doy = date %>% lubridate::mdy() %>% lubridate::yday()) %>%
  arrange(phenophase_code) %>%
  mutate(phenophase = factor(phenophase, levels = unique(phenophase))) %>%
  arrange(intensity_code) %>%
  mutate(intensity = factor(intensity, levels = unique(intensity))) %>%
  ggplot() +
  geom_point(aes(x = doy, y = intensity), alpha = 0.01, col = "dark green") +
  facet_wrap(. ~ phenophase * site, ncol = 2) +
  theme_classic() +
  labs(
    x = "Day of year",
    y = "Intensity"
  )
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" alt="Intensity of phenophase status." width="672" />
<p class="caption">
<span id="fig:unnamed-chunk-6"></span>Figure 3: Intensity of phenophase status.
</p>

</div>

## Continuous phenology data

``` r
dat_continuous_3m <- read_csv("data/continuous_3m.csv")

dat_continuous_3m %>%
  ggplot() +
  geom_line(aes(x = date, y = evi, group = id), alpha = 0.01, col = "dark green") +
  facet_wrap(. ~ site) +
  theme_classic() +
  labs(
    x = "Date",
    y = "EVI"
  )
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" alt="Enhanced vegetation index at 3 m resolution." width="672" />
<p class="caption">
<span id="fig:unnamed-chunk-7"></span>Figure 4: Enhanced vegetation index at 3 m resolution.
</p>

</div>

``` r
dat_continuous_500m <- read_csv("data/continuous_500m.csv")

dat_continuous_500m %>%
  ggplot() +
  geom_line(aes(x = date, y = evi), col = "dark green") +
  facet_wrap(. ~ site) +
  theme_classic() +
  labs(
    x = "Date",
    y = "EVI"
  )
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" alt="Enhanced vegetation index at 500 m resolution." width="672" />
<p class="caption">
<span id="fig:unnamed-chunk-8"></span>Figure 5: Enhanced vegetation index at 500 m resolution.
</p>

</div>

## Weather data

``` r
dat_weather <- read_csv("data/weather.csv")

dat_weather %>%
  gather(key = "variable", value = "value", -site, -date) %>%
  ggplot() +
  geom_line(aes(x = date, y = value, col = variable)) +
  facet_wrap(. ~ variable * site, scales = "free_y", ncol = 2) +
  theme_classic() +
  labs(
    x = "Date",
    y = "Value"
  )
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" alt="Weather variables at two sites." width="672" />
<p class="caption">
<span id="fig:unnamed-chunk-9"></span>Figure 6: Weather variables at two sites.
</p>

</div>