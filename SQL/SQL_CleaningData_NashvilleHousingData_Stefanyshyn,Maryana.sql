-- Data Cleaning using SQL 

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--Standardize Data Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDatae)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



-- Populate Property Address Data

SELECT PropertyAddress 
FROM PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is NULL

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
Order by ParcelID



--Joining the same exact Table to itself on the same parcel id to populate NULL address values
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b 
    on a.ParcelID=b.ParcelID 
    and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is NULL

--Updating the table
Update a 
SET PropertyAdress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b 
    on a.ParcelID=b.ParcelID 
    and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is NULL



-- Breaking out Address into Individual Columns (Address, City, State). Adding commas where needed.

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address 
From PortfolioProject.dbo.NashvilleHousing

-- Separating columns to add commas
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

--Split address table
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

--Split city table
ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 

--Split state table
ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



--- Change Y and N to Yes and No in 'Sold as Vacant' Field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END
From Portfolio.Project.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
        When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END



--Removing Duplicates

WITH RowNumCTE AS(
Select * ,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference 
                     ORDER BY 
                        UniqueID 
                      ) row_num


FROM PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)

--finding the duplicates
Select*
FROM RowNumCTE
Where row_num >1
Order by PropertyAddress

--deleting duplicates
DELETE 
FROM RowNumCTE
Where row_num >1
Order by PropertyAddress




--Delete Unused Columns 

Select *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate