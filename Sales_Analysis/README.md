# Customer Behaviour Analysis | Python, SQL & Power BI

## Project Overview

This project analyses customer shopping behaviour using **Python, MySQL, and Power BI**. It covers data cleaning, feature engineering, database integration, SQL-based business analysis, and interactive dashboard development.

The objective is to understand customer purchasing patterns, product performance, discount usage, subscription behaviour, customer segments, and spending trends across age groups.

## Tools and Technologies

- **Python:** pandas for data cleaning, exploration, and feature engineering
- **MySQL:** storing prepared data and answering business questions
- **SQLAlchemy and PyMySQL:** connecting Python to MySQL
- **Power BI:** creating interactive dashboards and visualisations
- **Git and GitHub:** version control and project documentation

## Dataset Description

The project uses `customer_shopping_behavior.csv`, which contains 3,900 records and 18 original columns.

| Column | Description |
|---|---|
| Customer ID | Customer identifier |
| Age | Customer age |
| Gender | Customer gender |
| Item Purchased | Purchased product |
| Category | Product category |
| Purchase Amount (USD) | Recorded purchase amount |
| Location | Customer location |
| Size | Product size |
| Color | Product colour |
| Season | Associated season |
| Review Rating | Customer review rating |
| Subscription Status | Subscription indicator |
| Shipping Type | Shipping method |
| Discount Applied | Discount usage indicator |
| Promo Code Used | Promo code usage indicator |
| Previous Purchases | Number of previous purchases |
| Payment Method | Payment method |
| Frequency of Purchases | Purchase frequency category |

## 1. Python Data Cleaning and Feature Engineering

The Python workflow uses pandas to prepare the dataset for analysis.

### Data exploration
- Loads the CSV using `pd.read_csv()`.
- Inspects the first records using `df.head()`.
- Reviews column data types and non-null values using `df.info()`.
- Generates descriptive statistics using `df.describe(include='all')`.
- Identifies missing values using `df.isnull().sum()`.

### Missing-value treatment

Missing review ratings are filled using the median rating within each product category.

```python
df['Review Rating'] = (
    df.groupby('Category')['Review Rating']
      .transform(lambda x: x.fillna(x.median()))
)
```

This preserves category-level differences when imputing missing ratings.

### Age-group creation

The `pd.qcut()` function divides customers into four age-based quartile groups:

```python
labels = [
    'Young Adult',
    'Adult',
    'Middle-aged',
    'Senior'
]

df['age_group'] = pd.qcut(
    df['age'],
    q=4,
    labels=labels
)
```

These are quartile-based groups, so their age boundaries depend on the dataset rather than predefined demographic ranges.

### Purchase-frequency conversion

A new column, `purchase_frequency_days`, converts categorical purchase frequencies into approximate day intervals.

Examples include:

- Weekly: 7 days
- Fortnightly: 14 days
- Monthly: 30 days
- Quarterly: 90 days
- Annually: 365 days

This feature makes purchase frequency easier to analyse numerically.

### Data preparation

The workflow compares `discount_applied` and `promo_code_used` and then removes `promo_code_used` from the prepared DataFrame.

**Note:** These columns should only be treated as interchangeable if the business definition supports that assumption.

## 2. MySQL Database Integration

The prepared DataFrame is loaded into a MySQL table named `customer` using SQLAlchemy.

```python
df.to_sql(
    name='customer',
    con=engine,
    if_exists='replace',
    index=False,
    chunksize=1000
)
```

The `replace` option drops and recreates the target table. Use it carefully because it overwrites the existing table and its data.

The database used for this project is:

```sql
CREATE DATABASE customer_behaviour;
USE customer_behaviour;

SELECT *
FROM customer
LIMIT 10;
```

### Important column-name alignment

The original CSV contains names such as `Customer ID` and `Purchase Amount (USD)`, whereas the SQL queries expect names such as `customer_id` and `purchase_amount`.

Standardise the DataFrame column names before loading it into MySQL, or update the SQL queries to match the actual schema. For example, after converting column names to lowercase snake case, rename `purchase_amount_usd` to `purchase_amount` if that is the name used by your queries.

The Python workflow must also retain `age_group` for the age-group SQL analysis.

## 3. SQL Business Analysis

The MySQL queries investigate the following business questions.

### Q1. Purchase amount by gender

Calculates the total recorded purchase amount for male and female customers using `SUM()` and `GROUP BY`.

```sql
SELECT
    gender,
    SUM(purchase_amount) AS total_purchase_amount
FROM customer
GROUP BY gender;
```

### Q2. Customers who used a discount but spent at least the average

Identifies customers whose discount indicator is `Yes` and whose purchase amount is greater than or equal to the overall average.

### Q3. Five highest-rated products

Ranks purchased items according to their average review rating using `AVG()`, `ROUND()`, and sorting.

### Q4. Average purchase amount by shipping type

Compares Standard and Express shipping using the average purchase amount.

```sql
SELECT
    shipping_type,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer
WHERE shipping_type IN ('Express', 'Standard')
GROUP BY shipping_type;
```

### Q5. Subscriber versus non-subscriber spending

Compares subscription groups by:
- Customer count
- Total recorded purchase amount
- Average purchase amount

This helps assess whether the two groups have different spending patterns.

### Q6. Products with the highest discount rates

Calculates the percentage of records with a discount for each item using conditional aggregation with `CASE`.

### Q7. Customer segmentation

Classifies customers according to `previous_purchases`:

- **New:** exactly one previous purchase
- **Returning:** between two and ten previous purchases
- **Loyal:** all other values

The query counts customers in each segment.

These thresholds follow the supplied SQL logic. Consider whether zero previous purchases should also be included in the New segment, depending on your intended definition.

### Q8. Top three products within each category

Uses a common table expression and `ROW_NUMBER()` to rank items by record count within each category.

To return only the top three products, filter the results using `WHERE item_rank <= 3` and order by category and rank.

### Q9. Repeat buyers and subscription status

Examines customers with more than five previous purchases and compares their counts by subscription status.

### Q10. Purchase amount by age group

Aggregates the recorded purchase amount for each Python-generated age group and sorts the groups by total amount.

**Interpretation note:** The supplied CSV has one unique customer ID per row. Consequently, counts represent customer records in this dataset, not necessarily separate transactions or orders. Likewise, the sum of purchase amounts should be described as recorded purchase amount unless it is confirmed to represent company revenue.

## 4. Power BI Dashboard

The Power BI report provides an interactive view of customer shopping behaviour.

### KPI cards
- Number of customers
- Average purchase amount
- Average review rating

### Visualisations
- Purchase amount by product category
- Customer count by product category
- Customer distribution by subscription status
- Purchase amount by age group
- Customer count by age group

### Interactive slicers
- Subscription status
- Gender
- Product category
- Shipping type

The slicers allow users to filter the dashboard and compare purchasing behaviour across customer groups.

## 5. Initial Dataset Findings

The following figures were calculated from the original CSV, before the Python workflow fills missing review ratings.

| Metric | Result |
|---|---:|
| Records | 3,900 |
| Unique customer IDs | 3,900 |
| Total recorded purchase amount | $233,081 |
| Average purchase amount | $59.76 |
| Average available review rating | 3.75 |
| Missing review ratings | 37 |
| Customer age range | 18–70 |

### Recorded purchase amount by category

| Category | Records | Total purchase amount |
|---|---:|---:|
| Clothing | 1,737 | $104,264 |
| Accessories | 1,240 | $74,200 |
| Footwear | 599 | $36,093 |
| Outerwear | 324 | $18,524 |

Clothing contributes the largest share of the recorded purchase amount in the source dataset, followed by Accessories.

### Subscription distribution

| Subscription status | Records | Share |
|---|---:|---:|
| Not subscribed | 2,847 | 73% |
| Subscribed | 1,053 | 27% |

Most records belong to customers marked as not subscribed. The SQL analysis can be used to compare spending between the groups, but the distribution alone does not establish that subscription status causes differences in spending.

## 6. How to Run the Project

1. Install Python and the required packages, including `pandas`, `sqlalchemy`, and `pymysql`.
2. Configure a valid MySQL connection for your local database.
3. Create and select the `customer_behaviour` database.
4. Run the Python script or notebook to clean the data and create the additional features.
5. Ensure the DataFrame column names match the MySQL schema expected by your SQL queries.
6. Load the prepared DataFrame into the `customer` table.
7. Execute the SQL queries to investigate the business questions.
8. Open `Customer_Behaviour_Dashboard.pbix` in Power BI Desktop and verify its data source.
9. Use the dashboard slicers to explore the results.

## 7. Data Quality and Limitations

- Missing review ratings are imputed using category-level medians, which can affect the resulting average ratings.
- Age groups are based on quartiles and may change if the dataset changes.
- Purchase-frequency intervals are approximations.
- Discount usage and promo-code usage are separate fields and may not have identical meanings.
- Customer record counts should not automatically be interpreted as order counts.
- Descriptive comparisons identify patterns but do not prove causation.
- Database credentials must not be committed to a public GitHub repository.

## Conclusion

This project demonstrates an end-to-end analytics workflow combining Python-based data preparation, MySQL querying, and Power BI visualisation. It applies practical data-cleaning techniques, feature engineering, SQL aggregations, subqueries, common table expressions, conditional calculations, and window functions to investigate customer behaviour and support data-driven business analysis.
