use AdventureWorks2016

--CREATE VIEW HRBi AS
--ALTER VIEW HRBi AS

select
p.BusinessEntityID, p.FirstName, p.MiddleName,p.LastName, p.PersonType,
pph.PhoneNumber,
ppht.Name as PhoneNumberType,
hre.BirthDate, hre.Gender, hre.HireDate, hre.JobTitle, hre.MaritalStatus, hre.OrganizationLevel, hre.SalariedFlag, hre.SickLeaveHours, hre.VacationHours,
hreh.EndDate as DepartmentSwitchDate,
hrdpt.Name as DepartmentName, hrdpt.GroupName as DepartmentGroup,
hrsft.Name as ShiftName, hrsft.StartTime as ShiftStartTime, hrsft.EndTime as ShiftEndTime,
hrpayh.Rate as PayRate, hrpayh.RateChangeDate as PayRateChangeDate, hrpayh.PayFrequency,
CASE
    WHEN hrpayh.Rate < 25 THEN 'Under 25'
    WHEN hrpayh.Rate < 50 THEN '25 - 49'
	WHEN hrpayh.Rate < 75 THEN '50 - 74'
	WHEN hrpayh.Rate < 100 THEN '75 - 99'
	ELSE 'Over 100'
END AS PayRateCategory,
DATEDIFF(yy,BirthDate,getdate()) AS Age,
CASE
    WHEN DATEDIFF(yy,BirthDate,getdate()) < 20 THEN 'Under 20'
    WHEN DATEDIFF(yy,BirthDate,getdate()) < 40 THEN '20 - 39'
	WHEN DATEDIFF(yy,BirthDate,getdate()) < 60 THEN '40 - 59'
	ELSE 'Over 60'
END AS AgeCategory
	from Person.Person as p
		inner join Person.PersonPhone as pph on
			p.BusinessEntityID = pph.BusinessEntityID
		inner join Person.PhoneNumberType as ppht on
			pph.PhoneNumberTypeID = ppht.PhoneNumberTypeID
		inner join HumanResources.Employee as hre on
			p.BusinessEntityID = hre.BusinessEntityID
		inner join HumanResources.EmployeeDepartmentHistory as hreh on
			p.BusinessEntityID = hreh.BusinessEntityID
		inner join HumanResources.Department as hrdpt on
			hreh.DepartmentID = hrdpt.DepartmentID
		inner join HumanResources.Shift as hrsft on
			hreh.ShiftID= hrsft.ShiftID
		inner join HumanResources.EmployeePayHistory as hrpayh on
			p.BusinessEntityID = hrpayh.BusinessEntityID

-- Department group, name, job counts
select DepartmentGroup, count(DISTINCT(BusinessEntityID)) as Counts from HRBi
group by DepartmentGroup
order by Counts DESC

select DepartmentName, count(DISTINCT(BusinessEntityID)) as Counts from HRBi
group by DepartmentName
order by Counts DESC

select JobTitle, count(DISTINCT(BusinessEntityID)) as Counts from HRBi
group by JobTitle
order by Counts DESC

-- Pay Rate Categorization
select
CASE
    WHEN PayRate < 25 THEN 'Under 25'
    WHEN PayRate < 50 THEN '25 - 49'
	WHEN PayRate < 75 THEN '50 - 74'
	WHEN PayRate < 100 THEN '75 - 99'
	ELSE 'Over 100'
END AS PayRateCategory
from HRBi

-- This will not round off the digit to the next place
SELECT BusinessEntityID,DATEDIFF(yy,BirthDate,getdate()) AS [Age In Years] from HRBi
order  by BusinessEntityID