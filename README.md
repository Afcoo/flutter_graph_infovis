# Assignment 02  -  202010098 Buyoung Mun

## The Datasets

I downloaded the population datasets and the fertility rate datasets for each province in Korea from KOSIS([https://kosis.kr/](https://kosis.kr/)).

   1. data.csv in [https://afcoo.github.io/infovis_web/assets/assets/data.csv](https://afcoo.github.io/infovis_web/assets/assets/data.csv)

      Fertility rate data for each province in Korea from 2000 to 2021

      Downloaded from 시군구/합계출산율, 모의 연령별 출산율 in KOSIS

   1. data2.csv in [https://afcoo.github.io/infovis_web/assets/assets/](https://afcoo.github.io/infovis_web/assets/assets/data.csv)[data2](https://afcoo.github.io/infovis_web/assets/assets/data2.csv)[.csv](https://afcoo.github.io/infovis_web/assets/assets/data.csv)

      Population data for each province in Korea from 2000 to 2021

      Downloaded from 행정구역(시군구)별, 성별 인구수 in KOSIS

All the datasets are re-encoded to UTF8 for compatibility in web.

## Teaser Images

We focused on providing an interactive tool to see how fertility rates have changed by year and province. Here are screenshots of the final version of this tool.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/FB566751-466E-4C12-845F-CBA662CC7E7A_2/tAoky4yHTp8BjyDt16PKdfHhTi1MyNzRkdguOCks6wkz/Image.png)

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/40250ADE-7865-4802-AF41-C3BB488336CF_2/i90xo5R4c6riwaxtGE40XoeDs1QngcHSpcI6qXLG17Uz/Image.png)

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/4E177DFA-0519-4834-AA29-49AA2B49474F_2/CfrWmuRylh4RDEboEuGWq3ZfmEJEM2qb7Q3uy6ufElMz/Image.png)

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/006AC0A6-371D-470D-BDEE-CD04076E6528_2/RD8lBxcyGOKlVlMpKDynwXIHJzkwLdsU6NKGkh7JtqAz/Image.png)

This tool can be tested on [https://afcoo.github.io/infovis_web/#/](https://afcoo.github.io/infovis_web/#/)

## Visualizations

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/E0FEAD2E-374D-4F5C-8B86-03DD45BD82B8_2/G491146oTN9XpB1Aew9XCQoX0VoHnQcHPpWkiCbCT6kz/Image.png)

I made 3 different views, and these can be changed by dropdown on top.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/DE4D077F-4824-449A-9776-CC0482381ABF_2/KbBuEN3v2SUTLZczyYGxr098DLj09Epc1ojjurZykNQz/Image.png)

Also, you can filter specific province. Click filter button on the left of bottom, and then use checkboxes for filtering provinces.

### Bar Chart

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/61DC9AE4-9EBF-4227-949B-AB980CD27861_2/RTcYoRLjckxRUHdhft9W2G0D8gqhlDGQxJyYAkJ0aJYz/Image.png)

In Bar Chart, the height of the bars represents the fertility rate for each province in a specific year. You can change the year by moving the slider above the chart, and observe the change in fertility rates for each province while moving the slider.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/31D93759-C83A-45BC-AE47-53B894C21506_2/xbgbRyEZ4Rx1BwhG8hyx1ZlVDxyhv3IZuBNy5HZFtkcz/Image.png)

You can sort the bar chart in ascending or descending order by checking the checkboxes on the right. This is useful to see which cities have the highest fertility rates by year.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/69EE2E46-2F06-4888-8873-804A1286D6EB_2/HaK4hgyT5mjzcJWqhSddJl92yPvCeYZT96emPEbPwy8z/Image.png)

When you hover your mouse over the bar, a tooltip appears with the province name and the detailed number of fertility rate. This allows you to see the details of the data in the bar chart.

### Line Chart

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/A62865DB-FAAB-487D-BC48-61658E597A29_2/yeatUc9xxTYNIgjNvV5OU2FoxyObY5PIYzfmXBFn7UUz/Image.png)

This line chart is useful for observing changes in fertility rates over time.

By default, the national average fertility rate is displayed, but you can select multiple provinces using the filter function mentioned above to display the graph at once.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/D61DDE10-D531-41CF-8A84-6FB708561269_2/Zy3iPjE6ydjH2jED9eTwVkDNzBwjVBPdGF8mI1wAHoIz/Image.png)

As with bar charts, a tooltip with details is displayed when you hover your mouse over the chart. The name of the province and year are displayed, and in graphs with multiple provinces, the details are displayed simultaneously. This works great for observing changes in fertility rates across provinces.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/6A0B9B9B-A6C2-43E9-A7F0-629261147862_2/zzF5hiR8ZftZOFiIBGv8Zibgkt6j4be4SIvT2Z9rZ5cz/Image.png)

You can manipulate the range of years on the x-axis and the range on the y-axis by manipulating the sliders. This makes it easier to see the subtle changes in the graph by scaling down the domain appropriately.

### Pie Chart

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/45B4E6DF-1615-42A2-89E1-346EB4D63912_2/w5yIUF4hovWdic95ZZCw7wyNFH2vyLYdhytchrXLxxgz/Image.png)

The pie chart shows the fertility rate through the diameter and the population rate through the proportion of the circle. The larger the diameter, the higher the fertility rate, and the larger the proportion of the circle, the higher the proportion of the population in South Korea.

Like the bar chart and line chart, it displays data by year, and you can change the year by manipulating the slider at the top.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/E49F66B6-6A46-4444-91C3-F159AAAD1296_2/V4IlyusibCDQBc0GxdsyDLzNr0N4yGCyvveRw21A9WMz/Image.png)

In the same way as a bar chart, you can sort the displayed data through the checkboxes on the left. It supports ascending and descending sorting, and you can also sort chart by fertility rate and population, respectively.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/E46314D8-D117-4371-9079-86E507BB433F_2/SL0BkC2t2KRmoGvOwRKESksVoKtXRp6kR1a2ijDAMrsz/Image.png)

When you hover the mouse over a bin in the pie chart, it highlights it. This makes it easy to see the fertility rate of a particular province in the text and the ratio of that province to the whole chart.

![Image.png](https://res.craft.do/user/full/19792442-4123-921c-b913-985b19f73df4/doc/683BFD4D-C5E1-47BF-BEC3-E6154E352518/2AA8AB80-C3B0-4461-90B3-82FBE75AAC79_2/Btt2OtFNP82k3ntZ4ABdak1CLjyHT2WdzyQ6yV07354z/Image.png)

By clicking on the gray labels with province’s name, you can highlight a specific province’s part. This highlighting remains during changing year and during applying sort, and can be useful for seeing changes in data for particular provinces.

## Development

For developing this tool, Flutter and fl_chart are used. Flutter is powerful tool for making multi-platform application, and also support web deploy. This tool is built with Flutter 3.10.5 and dart 3.0.5, and tested on chromium-based web browser(Google Chrome and Microsoft Edge).  This tool can be built for Windows or MacOS. but I haven’t tested yet.

All source codes are uploaded on [https://github.com/Afcoo/flutter_graph_infovis](https://github.com/Afcoo/flutter_graph_infovis), and web deploy version is uploaded on [https://github.com/Afcoo/infovis_web](https://github.com/Afcoo/infovis_web).

You can test web demo on [https://afcoo.github.io/infovis_web/#/](https://afcoo.github.io/infovis_web/#/)

