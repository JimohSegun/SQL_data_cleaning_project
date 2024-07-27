# Introduction

This project explores the NashvilleHousing data, emphasizing data cleaning for analysis. We focus on standardizing date formats, populating property address data, breaking addresses into individual columns (Address, City, State), changing "Y" and "N" to "Yes" and "No" in the "Sold as Vacant" field, removing duplicates, and deleting unused columns.

# Background

Driven by a focus on data analysis, this project explores the NashvilleHousing data with an emphasis on data cleaning.

### The areas of concentration for data cleaning were:

1. Standardizing date formats
2. Populating property address data
3. Breaking addresses into individual columns (Address, City, State)
4. Changing "Y" and "N" to "Yes" and "No" in the "Sold as Vacant" field
5. Removing duplicates
6. Deleting unused columns

# Tools I Used

In my deep dive into the NashvilleHousing data, I utilized several key tools:

- **SQL:** The foundation of my analysis, enabling me to query the database for data cleaning and analysis.
- **Git & GitHub:** Crucial for version control and sharing my SQL scripts and analysis, facilitating collaboration and project tracking.

# Analysis

Each query for this project was designed for data cleaning of NashvilleHousing data
Here is how I approached them.

### 1.Standardizing date formats

To format the date properly, I converted the date format from datetime to date, then updated the new date in a newly created column.

```sql
SELECT *
FROM PortfolioProject..NavshilleHousing


SELECT 
       SalesDateConverted , 
       CONVERT(Date , SaleDate)
From   
       PortfolioProject..NavshilleHousing

UPDATE NavshilleHousing
SET    SaleDate = CONVERT(Date , SaleDate)

 --if it does not work properly

ALTER TABLE [Nashville Housing Data for Data Cleaning]
ADD SalesDateConverted date ;

UPDATE NavshilleHousing
SET SalesDateConverted  = CONVERT(Date , SaleDate)

```


### 2. Populating Property Address Data

I wrote queries that helped me find the NULL values in the PropertyAddress column using ISNULL, which allowed me to replace NULL values with a specified replacement value.

```sql
SELECT 
       property_A.ParcelID, 
	   property_A.PropertyAddress, 
	   property_B.ParcelID, 
       property_B.PropertyAddress, 
	   ISNULL(property_A.PropertyAddress, property_B.PropertyAddress)
FROM
     PortfolioProject..NavshilleHousing property_A
JOIN 
      PortfolioProject..NavshilleHousing property_B
ON 
      property_A.ParcelID = property_B.ParcelID
AND 
      property_A.[UniqueID ] <> property_B.[UniqueID ]
	  WHERE 
      property_A.PropertyAddress IS null

--NOW UPADTE THE COLUMNS WITH EXISTING VALUE 
UPDATE  property_A
SET     PropertyAddress =  ISNULL(property_A.PropertyAddress, property_B.PropertyAddress)
FROM
      PortfolioProject..NavshilleHousing property_A
JOIN 
      PortfolioProject..NavshilleHousing property_B
ON 
      property_A.ParcelID = property_B.ParcelID
AND 
      property_A.[UniqueID ] <> property_B.[UniqueID ]
	  WHERE 
      property_A.PropertyAddress IS null

```

### 3. Breaking out Address into Individual Columns

This query helped break out the PropertyAddress into individual columns such as Address, City, and State.

```sql
SELECT 
      SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',', PropertyAddress)-1 ) AS Address, 
      SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM 
      PortfolioProject..NavshilleHousing

--Create two new columns and update the values with new values
ALTER TABLE NavshilleHousing
ADD PropertySplitAddress nvarchar(225);

UPDATE NavshilleHousing
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',', PropertyAddress)-1 )

ALTER TABLE NavshilleHousing
ADD PropertySplitCity nvarchar(225);

UPDATE  NavshilleHousing
SET     PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



select 
      OwnerAddress
From 
      PortfolioProject..NavshilleHousing
WHERE OwnerAddress IS NOT NULL

select 
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),  
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),  
       PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From 
       PortfolioProject..NavshilleHousing
WHERE 
       OwnerAddress IS NOT NULL

ALTER TABLE NavshilleHousing
ADD OwnersplitAddress nvarchar(255)

UPDATE NavshilleHousing
SET   OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NavshilleHousing
ADD    OwnersplitCity nvarchar(255)

UPDATE  NavshilleHousing
SET    OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NavshilleHousing
ADD OwnersplitState nvarchar(255)

UPDATE  NavshilleHousing
SET OwnersplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject..NavshilleHousing
```

### 4. Change Y and N to Yes and No in "Sold as Vacant" field

This query helps to change the "Sold as Vacant" field from "Y" and "N" to "Yes" and "No" using the CASE statement.

```sql
Select DISTINCT( SoldAsVacant),
CASE
    WHEN SoldAsVacant= 'N'THEN 'No'
	WHEN SoldAsVacant= 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END
From PortfolioProject..NavshilleHousing

UPDATE NavshilleHousing
SET SoldAsVacant = CASE
    WHEN SoldAsVacant= 'N'THEN 'No'
	WHEN SoldAsVacant= 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END
from PortfolioProject..NavshilleHousing

select SoldAsVacant
from  PortfolioProject..NavshilleHousing

```


### 5. Remove Duplicates
I removed any duplicates in the NashvilleHousing data.

```sql
WITH  Row_NumCTE AS (
SELECT *, 
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	              OwnerAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY 
	               UniqueID) AS row_num
FROM PortfolioProject..NavshilleHousing)

SELECT *
FROM Row_NumCTE
WHERE row_num > 1
~~~

Select *
From PortfolioProject.dbo.NashvilleHousing
```

### 6. Delete Unused Columns

This query deletes unused columns in our data.

```sql

SELECT *
FROM PortfolioProject..NavshilleHousing


ALTER TABLE NavshilleHousing
DROP COLUMS OwnerAddress, OwnerName
```
