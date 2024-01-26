select * 
from nashvillahousing

/*
data cleaning main objective  let's enjoy
*/

--------------------------------------------------------------------------------------------------
--standardize data format

select SaleDate
, convert(date,saledate)--or cast(saledate as date)
from nashvillahousing

update nashvillahousing
set SaleDate=convert(date,saledate)--idk why it's not working let's use alternative

alter table nashvillahousing
add saledateeupdated date;

update nashvillahousing
set saledateupdated =convert(date,SaleDate)

select saledtaeupdated
, convert(date,saledate)
from nashvillahousing

--------------------------------------------------------------------------------------------------
--populated property address date

select *
from nashvillahousing
--where PropertyAddress is null
order by [UniqueID ]

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress) 
from nashvillahousing a
join nashvillahousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null -- even b.PropertyAddressget updated obvious

update a --weare not going to say just anashvillahousing we have to mention alaise
Set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress) 
from nashvillahousing a
join nashvillahousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--i can do update thing with alter also

--------------------------------------------------------------------------------------------------
--breaking out address into indiviual columns (address,city,state)

select PropertyAddress
from nashvillahousing

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address--charindex basically returns index for particyular value in sql
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as address
from nashvillahousing

alter table nashvillahousing
add propertysplitaddress nvarchar(255);

update nashvillahousing
set propertysplitaddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table nashvillahousing
add propertysplitcity nvarchar(255);

update nashvillahousing
set propertysplitcity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select *
from nashvillahousing

--now we can even drop the columnn(propertyaddress) if we want 

select OwnerAddress
from nashvillahousing
--now we have owner adress which is in form od address,city,state but this time we use ""PARSENAME""

select 
PARSENAME(replace(OwnerAddress, ',' , '.'),1) --period is '.' so we're telling pasename to look for ',' instead of '.'
,PARSENAME(replace(OwnerAddress, ',' , '.'),2)
,PARSENAME(replace(OwnerAddress, ',' , '.'),3)--an awkyard thing is that parsename works backwards
from nashvillahousing

--an awkyard thing is that parsename works backwards SOOOO....

select 
PARSENAME(replace(OwnerAddress, ',' , '.'),3) --period is '.' so we're telling pasename to look for ',' instead of '.'
,PARSENAME(replace(OwnerAddress, ',' , '.'),2)
,PARSENAME(replace(OwnerAddress, ',' , '.'),1)--an awkyard thing is that parsename works backwards
from nashvillahousing

alter table nashvillahousing
add ownersplitaddress nvarchar(255);

update nashvillahousing
set ownersplitaddress =PARSENAME(replace(OwnerAddress, ',' , '.'),3)


alter table nashvillahousing
add ownersplitcity nvarchar(255);

update nashvillahousing
set ownersplitcity =PARSENAME(replace(OwnerAddress, ',' , '.'),2)

alter table nashvillahousing
add ownersplitstate nvarchar(255);

update nashvillahousing
set ownersplitstate =PARSENAME(replace(OwnerAddress, ',' , '.'),1)

select*
from nashvillahousing

--------------------------------------------------------------------------------------------------
--change y and N to Yes and N in  "sold as vacant" field


select distinct(SoldAsVacant),count(SoldAsVacant)
from nashvillahousing
group by SoldAsVacant


select SoldAsVacant
,case 
	when SoldAsVacant='y' then 'Yes'
	when SoldAsVacant='n' then 'No'
	else SoldAsVacant
end
from nashvillahousing

update nashvillahousing
set SoldAsVacant=case 
	when SoldAsVacant='y' then 'Yes'
	when SoldAsVacant='n' then 'No'
	else SoldAsVacant
end
from nashvillahousing


select distinct(SoldAsVacant),count(SoldAsVacant)
from nashvillahousing
group by SoldAsVacant

--------------------------------------------------------------------------------------------------
--remove dulpicate 

--ALTHOUGH the guy from i learning suggest me not to delet actual data from database 
--that's not a right practice unitl unless you're getting paid 😉

with rownumcte AS (
select *,
	Row_number() over(
	partition by parcelid,
				propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by 
					uniqueid
					)row_num
from nashvillahousing
)
delete
from rownumcte
where row_num>1

select *
from rownumcte
where row_num>1 -- rememeber slect or delete staement will not be executre alone it onky works with with statement 


--for a time we are assuming in our tables we don't have any uniqueid column now we have some rows to same you we DON"T need them
select *
from nashvillahousing

--------------------------------------------------------------------------------------------------
--delete unused columns

select *
from nashvillahousing

alter table nashvillahousing
drop column propertyaddress,saledate,owneraddress,taxdistrict

---------------------------AND WITH THIS WE HAVE DONE DATA CLEANING WITH DIFF-DIFF CONDITIONS------------------------------------

---------------------------and more 





--------------------------------------------------------------------------------------------------









--------------------------------------------------------------------------------------------------










--------------------------------------------------------------------------------------------------