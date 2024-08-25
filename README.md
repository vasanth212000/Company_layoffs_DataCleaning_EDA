# Company_layoffs_DataCleaning_EDA
Company Layoffs Data Cleaning &amp; EDA This project involves data cleaning and exploratory analysis of company layoffs. It includes SQL scripts for removing duplicates, standardizing data, and analyzing layoffs by company, industry, country, and time. Includes data_cleaning_code.sql and eda_code.sql

## Overview

This project involves data cleaning and exploratory data analysis (EDA) for company layoffs data. It includes SQL scripts to clean the data by removing duplicates, standardizing fields, and performing various exploratory analyses to uncover insights.

## Project Structure

- `data_cleaning_code.sql`: SQL script for data cleaning tasks including:
  - Removing duplicate records
  - Standardizing text fields
  - Handling missing values
  
- `eda_code.sql`: SQL script for exploratory data analysis including:
  - Analyzing layoffs by company, industry, and country
  - Examining layoffs over time
  - Generating summaries and trends

## Features

- **Data Cleaning**: 
  - Removal of duplicate records
  - Standardization of text fields (e.g., company names, industries)
  - Conversion of date formats
  - Handling of null and blank values

- **Exploratory Data Analysis**:
  - Analysis of layoffs by company and industry
  - Country-based layoffs analysis
  - Time-based trends in layoffs
  - Calculation of rolling totals

## Getting Started

### Prerequisites

- MySQL or compatible SQL database system
- Access to the dataset (`layoffs` table)

### How to Run

1. **Setup Database**:
   - Create a new database or use an existing one.
   - Import the dataset into the database.

2. **Run Data Cleaning Script**:
   - Execute `data_cleaning_code.sql` to clean and standardize the data.

3. **Run EDA Script**:
   - Execute `eda_code.sql` to perform exploratory data analysis and generate insights.

### Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Company_Layoffs_DataCleaning_EDA.git
