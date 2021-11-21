/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [portfolio projects].[dbo].[NashvilleHousingData ]


  --Lets Clean some Data
-------------------------------------------
  --Standardize date format
  Update NashvilleHousingData
	SET SaleDate = CONVERT(Date,SaleDate)


	-- lets try add a new column with saleDate as saleDateConverted


ALTER TABLE NashvilleHousingData
Add SaleDateConverted Date;

Select saleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Projects].[dbo].[NashvilleHousingData]


-- Lets Populate Property Address data 

	Select *
	From [portfolio projects]..[NashvilleHousingData ]
	--Where PropertyAddress is null  
	order by ParcelID

	-- we can see that some of the row in parcelID is duplicate and propertyAddress is also same
	--so lets JOIN them.

	Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [portfolio projects].[dbo].[NashvilleHousingData] a
JOIN [portfolio projects].[dbo].[NashvilleHousingData] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--we got propertyAddress where it is null and where parcelID is repeated . 
--so here just fill those Null with as propertyaddress .

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [portfolio projects].[dbo].[NashvilleHousingData] a
JOIN [portfolio projects].[dbo].[NashvilleHousingData] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- lets Break out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [portfolio projects].[dbo].[NashvilleHousingData]


--Here we can see that we got a seperate ','
--we use a command called charindex(seperator,column) which gives the character index value.
--in substring(column,startposition, index)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as CITY

From [portfolio projects].[dbo].[NashvilleHousingData]
--lets update this to table

--i dont know why update function is not working. 
 --So adding as new columns

ALTER TABLE NashvilleHousingData
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousingData
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))

--Now we are added those 2 split columns to NashvilleHousingData

Select *
From [portfolio projects].[dbo].[NashvilleHousingData]

--Looks perfect

---NOW lets check out ownerAddress , which is bit scarey.
Select OwnerAddress
From [portfolio projects].[dbo].[NashvilleHousingData]

--we have command called Parsename - which returns information based on split words with "." from end
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [portfolio projects].[dbo].[NashvilleHousingData]

ALTER TABLE NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousingData
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [portfolio projects].[dbo].[NashvilleHousingData]

-- BY observing SoldAsVacanat column.  some of the rows are named as N instead of No ,and Y instead of yes. 
--So Changing Y and N to Yes and No 

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From [portfolio projects].[dbo].[NashvilleHousingData]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [portfolio projects].[dbo].[NashvilleHousingData]



Update [NashvilleHousingData ]
SET SoldAsVacant=CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




Select *
From [portfolio projects].[dbo].[NashvilleHousingData]