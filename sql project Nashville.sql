
Select *
From PortfolioProject.dbo.NashvilleHousing

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

update PortfolioProject..NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

--Populate Property Addres Date 

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
	where a.PropertyAddress is null


--Breaking Out Indivdual Columns (Address,City,State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

--looking to the char index

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
CHARINDEX(',', PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing

--not starting from the first position anymore

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN( PropertyAddress)) AS Address

From PortfolioProject.dbo.NashvilleHousing

--greating 2 new columns and add that value in 

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN( PropertyAddress))

--test 
select*
From PortfolioProject.dbo.NashvilleHousing

--The Owner Address
--PARSE NAME

select
PARSENAME(replace(OwnerAddress,',', '.'), 3)
,PARSENAME(replace(OwnerAddress,',', '.'), 2)
,PARSENAME(replace(OwnerAddress,',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing




ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',', '.'), 3)



ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress,',', '.'), 2)



ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress,',', '.'), 1)


--Change Y And N To Yes And No "Sold AS Vacant"

select Distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant
, case  when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
        end 
from PortfolioProject..NashvilleHousing



update PortfolioProject..NashvilleHousing
set SoldAsVacant = case  when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
        end 


--Remove The Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- now we delete them 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


--Delete Unused Columns 
select*
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

