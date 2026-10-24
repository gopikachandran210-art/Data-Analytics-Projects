# Airbnb NYC Listings — Exploratory Data Analysis

An exploratory data analysis (EDA) of New York City Airbnb listings, done in a
Jupyter notebook with pandas, seaborn, and matplotlib. The project cleans the
raw listings data, looks at how each variable is distributed, and then
examines how price relates to location, room type, reviews, and availability.

---

## Repository Contents

| File | Description |
|---|---|
| `airbnb.ipynb` | The analysis notebook (data loading, cleaning, EDA, visualizations) |
| `datasets.csv` | The raw listings data: 20,770 rows × 22 columns (~4.3 MB) |

---

## Dataset

Each row is one Airbnb listing in New York City.

| Column | Description |
|---|---|
| `id` | Unique listing ID |
| `name` | Listing title (includes rating, bedroom, and bed summary) |
| `host_id`, `host_name` | Host identifier and name |
| `neighbourhood_group` | Borough (Manhattan, Brooklyn, Queens, Bronx, Staten Island) |
| `neighbourhood` | Neighbourhood within the borough |
| `latitude`, `longitude` | Listing coordinates |
| `room_type` | Entire home/apt, Private room, Shared room, or Hotel room |
| `price` | Nightly price in USD |
| `minimum_nights` | Minimum stay required |
| `number_of_reviews` | Total reviews |
| `last_review` | Date of most recent review (`dd/mm/yy` format) |
| `reviews_per_month` | Average reviews per month |
| `calculated_host_listings_count` | Number of listings the host manages |
| `availability_365` | Days available in the next 365 days |
| `number_of_reviews_ltm` | Reviews in the last 12 months |
| `license` | Registration status (e.g. `No License`, `Exempt`, or a license number) |
| `rating` | Average guest rating |
| `bedrooms`, `beds`, `baths` | Property size details (`bedrooms` and `baths` contain text values such as `Studio` and `Not specified`) |

### Quick facts

- **Boroughs:** Manhattan (8,050), Brooklyn (7,719), Queens (3,761), Bronx (949), Staten Island (291)
- **Room types:** Entire home/apt (11,555), Private room (8,803), Shared room (293), Hotel room (112)
- **Price:** median $125, mean ~$188, range $10 to $100,000. The extreme maximum is why the notebook filters outliers before plotting.
- **Review dates:** from December 2011 to January 2024
- **Data quality:** 7 rows are missing most fields, 34 rows are missing `price`, and 12 rows are exact duplicates

---

## What the Notebook Does

1. **Setup and loading:** imports pandas, numpy, seaborn, and matplotlib, then reads `datasets.csv` (with `encoding_errors='ignore'`).
2. **Initial exploration:** `head`, `tail`, `shape`, `info`, and `describe` to understand the structure.
3. **Data cleaning**
   - Drops rows with missing values
   - Removes duplicate rows
   - Converts `id` and `host_id` to object type, since they are identifiers and not numbers to do arithmetic on
4. **Univariate analysis:** price boxplot and histogram, and the distribution of `availability_365`. Listings priced at $1,500 or more are excluded from the plots so a few extreme values don't hide the main distribution.
5. **Feature engineering:** adds `price per bed` (`price / beds`) and compares average price and price per bed by borough.
6. **Bivariate analysis**
   - Price by borough and room type (bar plot)
   - Price vs. number of reviews, colored by borough (scatter plot)
   - Pair plot of price, minimum nights, reviews, and availability, split by room type
   - Geographic scatter plot of listings by latitude and longitude
   - Correlation heatmap of the numeric columns

---

## Getting Started

### Requirements

- Python 3.9+
- pandas, numpy, matplotlib, seaborn
- Jupyter Notebook or JupyterLab

### Setup

```bash
git clone <your-repo-url>
cd <your-repo-folder>

python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

pip install pandas numpy matplotlib seaborn jupyter
jupyter notebook airbnb.ipynb
```

Keep `datasets.csv` in the same folder as the notebook, because the notebook
loads it with a relative path.

---

## Notes and Known Issues

- **Cell order:** the "average price per bed" group-by cell runs *before* the cell that creates the `price per bed` column, so it raises an error when run top to bottom. Move the Feature Engineering cell above it.
- **Copy warnings:** `df` is a filtered slice of `data`, so adding a column to it can trigger pandas' `SettingWithCopyWarning`. Using `df = data[data['price'] < 1500].copy()` avoids this.
- **Division by zero:** `price per bed` divides by `beds`, so any listing with zero beds would produce an infinite value. Check this before averaging.
- **Mixed-type columns:** `bedrooms` and `baths` contain text such as `Studio` and `Not specified`, so they need cleaning before they can be used numerically.
- **Saved outputs:** the notebook currently has no saved outputs or markdown cells (section headings are written inside code cells). Run all cells to reproduce the charts, and consider converting headings to markdown cells for readability.

---

## Possible Next Steps

- Predict price with a regression model (linear regression or gradient boosting)
- Analyze neighbourhood-level pricing, not just borough-level
- Study how license status relates to price and availability
- Parse the rating and bedroom details into clean numeric features
- Build an interactive map of listings (for example with Folium or Plotly)

---

## Tools

Python · pandas · NumPy · Matplotlib · seaborn · Jupyter
