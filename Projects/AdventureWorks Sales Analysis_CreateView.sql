use AdventureWorks2016

--CREATE VIEW SalesBi AS
--ALTER VIEW SalesBi AS

select
sod.SalesOrderID, soh.OrderDate,
pp.FirstName + ' ' + LastName as FullName,
p.Name as ProductName, p.Color as ProductColor,
ps.Name as ProductCategory,
pc.Name as ProductSubCategory,
sod.OrderQty as OrderQuantity, sod.LineTotal as OrderSubTotal,
soh.CustomerID as SalesCustomerID, soh.TotalDue as SalesTotal, soh.OnlineOrderFlag as SalesOnline,
so.Category as DiscountCategory, so.Type as DiscountType, so.Description as DiscountDescription, so.DiscountPct as DiscountPercentage,
st.Name as SalesCountry
	from Sales.SalesOrderDetail as sod
		inner join sales.SalesOrderHeader as soh
			on sod.SalesOrderID = soh.SalesOrderID
		inner join sales.SalesTerritory as st
			on soh.TerritoryID = st.TerritoryID
		inner join sales.SpecialOffer as so
			on sod.SpecialOfferID = so.SpecialOfferID
		inner join Production.Product as p
			on sod.ProductID = p.ProductID
		inner join Production.ProductSubcategory as ps
			on p.ProductSubcategoryID = ps.ProductSubcategoryID
		inner join Production.ProductCategory as pc
			on ps.ProductCategoryID = pc.ProductCategoryID
		inner join Sales.Customer as sc
			on soh.CustomerID = sc.CustomerID
			inner join Person.Person as pp
				on pp.BusinessEntityID = sc.PersonID


--- TOP 10 CUSTOMER SALES
select top(10)
FullName,
SUM(SalesTotal) AS TOTAL
	from SalesBi
	group by FullName
	order by TOTAL DESC

-- Select the columns required
select
SalesOrderID, FullName, SalesTotal
	from SalesBi
		where
			FullName in(
				-- Select top 10 sales along with customer name
				select top(10)
				FullName
				from SalesBi
				group by FullName
				order by SUM(OrderSubTotal) DESC
			)
