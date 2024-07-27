
SELECT *
FROM PortfolioProject..NavshilleHousing


--Standardise Date Format...................................................................................................................
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



--Populate Property Address Data................................................................................................................
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




--BREAKING Out Address into Individaul columns (Address, City, State).....................................................................................
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


--Change Y AND N to YES AND NO in "SOLD AS Vacant" field.....................................................................................
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




--REMOVING DUPLICATES.........................................................................................................................
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




--Delete Unused Columns.................................................................................................................

SELECT *
FROM PortfolioProject..NavshilleHousing



ALTER TABLE NavshilleHousing
DROP COLUMS OwnerAddress, OwnerName