# AnalystLab-Africa-Week-1-2-Data-Cleaning-and-Exploratory-Data-Analysis
Data cleaning and EDA project on two datasets: Online Retail (e-commerce transactions) and Netflix Movies & TV Shows.
Tools Used
 • MySQL — Online Retail dataset (import, cleaning, EDA queries)
 • Excel — Netflix dataset (cleaning, pivot tables, EDA, visualizations)

 ├── online-retail/
│   ├── online_retail_cleaned.csv
│   ├── cleaning_and_eda_queries.sql
│   └── charts/ (5 exported visualizations)
├── netflix/
│   ├── netflix_titles_cleaned.xlsx
│   └── charts/ (5 visualizations, included in workbook)
├── Online_Retail_Cleaning_Summary.docx
└── One_Page_Summary_Report.docx


Online Retail (MySQL)
Cleaning steps:
 • Loaded ~541,909 rows via LOAD DATA LOCAL INFILE (Table Data Import Wizard failed on date/type mismatches)
 • Removed 5,268 exact duplicate rows
 • Flagged rather than deleted ambiguous records:
 • IsGuest — missing CustomerID (135,080 rows)
 • IsCancelledOrReturn — negative Quantity (10,587 rows)
 • IsInvalidPrice — UnitPrice ≤ 0 (2,512 rows)
 • Standardized Country values (USA → United States of America, EIRE → Ireland, RSA → South Africa), including fixing hidden carriage-return characters that were blocking exact-match updates
Key findings:
 • UK generates ~31x more revenue than the next-highest country (Netherlands)
 • Top “seller” by quantity is skewed by a single 80,995-unit bulk order — order-count analysis shows “White Hanging Heart T-Light Holder” as the more genuinely popular product
 • Sales spike Sept–Nov (seasonal); Dec 2011 data is partial (through Dec 9 only)
 • Avg. 4.27 orders and ~£2,048 spend per known customer; long-tail distribution (most customers spend under £500)
Netflix (Excel)
Cleaning steps:
 • Removed junk/broken rows caused by CSV parsing issues (unescaped commas shifting column data)
 • Fixed Excel auto-converting date-like titles into real dates (re-imported with Title column forced to Text)
 • Filled missing director/cast/country/rating with “Unknown”; left missing date_added/duration blank (documented rather than guessed)
 • Corrected 3 rows where a missing rating value had shifted duration data into the rating column
Key findings:
 • 70% Movies / 30% TV Shows
 • Content additions grew sharply from 2016, peaking in 2019 (2,016 titles)
 • US is the dominant content-producing country (2,817), far ahead of India (972) and UK (419)
 • TV-MA + TV-14 make up ~61% of the catalog — skewed toward mature/teen content
 • “Dramas, International Movies” is the most common genre combination
Deliverables
 • Cleaned datasets (CSV / XLSX)
 • SQL queries (cleaning + EDA) for Online Retail
 • 5 visualizations per dataset
 • Cleaning summary and one-page report (see .docx files)
