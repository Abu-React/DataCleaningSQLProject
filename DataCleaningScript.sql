--Regular check and preview the dataframe

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;

-------------------------------------------------------------------------------------------

--Set a strandard date format on the SaleDate column.

SELECT NewSaleDate, CONVERT(date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD NewSaleDate Date;

UPDATE NashvilleHousing
SET NewSaleDate = CONVERT(date,SaleDate)

------------------------------------------------------------------------------------------------

--Populate property address.

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is NUll;
--ORDER BY ParcelID;


--Populating null values on property address. 
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

-----------------------------------------------------------------------------------------------------
--Updating the null PropertyAddress column.

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

-------------------------------------------------------------------------------------------------------------------------
--Breaking out the PropertyAdress into two parts (Address, City )

Select PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD Address NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertyCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
FROM PortfolioProject.dbo.NashvilleHousing;

-----------------------------------------------------------------------------------------------------------------
--Breraking out the OwnerAdress into three parts (Address, City, State)

Select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress,',', '.'),3),PARSENAME(REPLACE(OwnerAddress,',', '.'),2),PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
FROM PortfolioProject.dbo.NashvilleHousing;

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerCity NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerState NVARCHAR(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

Select *
FROM PortfolioProject.dbo.NashvilleHousing;

----------------------------------------------------------------------------------------------------------------------------
--Change Y and N from SoldAsVacant column to Yes and No.

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' WHEN SoldAsVacant = 'N' THEN 'NO' ELSE SoldAsVacant END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' WHEN SoldAsVacant = 'N' THEN 'NO' ELSE SoldAsVacant END

-----------------------------------------------------------------------------------------------------------------------------
--Delete Duplicates.

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM PortfolioProject.dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

---------------------------------------------------------------------------------------------------------------------
--Dropping unused columns.

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress