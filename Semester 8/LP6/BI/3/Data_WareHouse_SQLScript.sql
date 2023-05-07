--DROP DATABASE Sales_DW 
GO
Create database Sales_DW
Go

Use Sales_DW
Go

--Create Customer dimension table in Data Warehouse which will hold customer personal details.

Create table DimCustomer
(
CustomerID int primary key identity,
CustomerAltID varchar(10) not null,
CustomerName varchar(50),
Gender varchar(20)
)
go

--Fill the Customer dimension with sample Values

Insert into DimCustomer(CustomerAltID,CustomerName,Gender)values
('IMI-001','Henry Ford','M'),
('IMI-002','Bill Gates','M'),
('IMI-003','Muskan Shaikh','F'),
('IMI-004','Richard Thrubin','M'),
('IMI-005','Emma Wattson','F');
Go

--Create basic level of Product Dimension table without considering any Category or Subcategory.

Create table DimProduct
(
ProductKey int primary key identity,
ProductAltKey varchar(10)not null,
ProductName varchar(100),
ProductActualCost money,
ProductSalesCost money

)
Go

--Fill the Product dimension with sample Values

Insert into DimProduct(ProductAltKey,ProductName, ProductActualCost, ProductSalesCost)values
('ITM-001','Wheat Floor 1kg',5.50,6.50),
('ITM-002','Rice Grains 1kg',22.50,24),
('ITM-003','SunFlower Oil 1 ltr',42,43.5),
('ITM-004','Nirma Soap',18,20),
('ITM-005','Arial Washing Powder 1kg',135,139);
GO
--Create Store Dimension table which will hold details related stores available across various place.
Create table DimStores
(
StoreID int primary key identity,
StoreAltID varchar(10)not null,
StoreName varchar(100),
StoreLocation varchar(100),
City varchar(100),
State varchar(100),
Country varchar(100)
)
Go
--Fill the Store Dimension with sample Values
Insert into DimStores(StoreAltID,StoreName,StoreLocation,City,State,Country )values
('LOC-A1','X-Mart','S.P. RingRoad','Ahmedabad','Guj','India'),
('LOC-A2','X-Mart','Maninagar','Ahmedabad','Guj','India'),
('LOC-A3','X-Mart','Sivranjani','Ahmedabad','Guj','India');
Go

--Create Dimension Sales Person table which will hold details related stores available across various place.

Create table DimSalesPerson
(
SalesPersonID int primary key identity,
SalesPersonAltID varchar(10)not null,
SalesPersonName varchar(100),
StoreID int,
City varchar(100),
State varchar(100),
Country varchar(100)
)
Go

--Fill the Dimension Sales Person with sample Values

Insert into DimSalesPerson(SalesPersonAltID,SalesPersonName,StoreID,City,State,Country )values
('SP-DMSPR1','Ashish',1,'Ahmedabad','Guj','India'),
('SP-DMSPR2','Ketan',1,'Ahmedabad','Guj','India'),
('SP-DMNGR1','Srinivas',2,'Ahmedabad','Guj','India'),
('SP-DMNGR2','Saad',2,'Ahmedabad','Guj','India'),
('SP-DMSVR1','Jasmin',3,'Ahmedabad','Guj','India'),
('SP-DMSVR2','Jacob',3,'Ahmedabad','Guj','India');
Go




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DimTime](
	[TimeKey] [int] NOT NULL,
	[TimeAltKey] [int] NOT NULL,
	[Time30] [varchar](8) NOT NULL,
	[Hour30] [tinyint] NOT NULL,
	[MinuteNumber] [tinyint] NOT NULL,
	[SecondNumber] [tinyint] NOT NULL,
	[TimeInSecond] [int] NOT NULL,
	[HourlyBucket] varchar(15)not null,
	[DayTimeBucketGroupKey] int not null,
	[DayTimeBucket] varchar(100) not null
 CONSTRAINT [PK_DimTime] PRIMARY KEY CLUSTERED 
 (
 [TimeKey] ASC
 )
 WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
 ) 
 ON [PRIMARY]

 GO

 SET ANSI_PADDING OFF
 GO


/***** Create Stored procedure In Test_DW and Run SP To Fill Time Dimension with Values****/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FillDimTime]
as
BEGIN

--Specify Total Number of Hours You need to fill in Time Dimension
DECLARE @Size INTEGER
--iF @Size=32 THEN This will Fill values Upto 32:59 hr in Time Dimension 
Set @Size=23

DECLARE @hour INTEGER
DECLARE @minute INTEGER
DECLARE @second INTEGER
DECLARE @k INTEGER
DECLARE @TimeAltKey INTEGER
DECLARE @TimeInSeconds INTEGER
DECLARE @Time30 varchar(25)
DECLARE @Hour30 varchar(4)
DECLARE @Minute30 varchar(4)
DECLARE @Second30 varchar(4)
DECLARE @HourBucket varchar(15)
DECLARE @HourBucketGroupKey int
DECLARE @DayTimeBucket varchar(100)
DECLARE @DayTimeBucketGroupKey int

SET @hour = 0
SET @minute = 0
SET @second  = 0
SET @k  = 0
SET @TimeAltKey  = 0

WHILE(@hour<= @Size ) 
BEGIN
	
	if (@hour <10 )
		 begin
		 set @Hour30 = '0' + cast( @hour as varchar(10))
		 end
	else
		 begin
		 set @Hour30 = @hour 
		 end
	--Create Hour Bucket Value	 
	set @HourBucket= @Hour30+':00' +'-' +@Hour30+':59' 
	
	
	WHILE(@minute <= 59) 
	BEGIN
		WHILE(@second  <= 59)
		 BEGIN	
	 
		 set @TimeAltKey = @hour *10000 +@minute*100 +@second 
		 set @TimeInSeconds =@hour * 3600 + @minute *60 +@second 
		
		 If @minute  <10 
		   begin
		   set @Minute30  = '0' + cast ( @minute as varchar(10) )
		   end
		 else
		   begin
		   set @Minute30  = @minute 
		   end
		 
		 if @second   <10 
		   begin
		   set @Second30   = '0' + cast ( @second as varchar(10) )
		   end
		 else
		   begin
		   set @Second30  = @second 
		   end
	--Concatenate values for Time30	 
	set @Time30 = @Hour30 +':'+@Minute30 +':'+@Second30 
		 
    --DayTimeBucketGroupKey can be used in Sorting of DayTime Bucket In proper Order
    SELECT @DayTimeBucketGroupKey =
        CASE
			 WHEN (@TimeAltKey >= 00000 AND  @TimeAltKey <= 25959) THEN 0 
			 WHEN (@TimeAltKey >= 30000 AND  @TimeAltKey <= 65959) THEN 1 
             WHEN (@TimeAltKey >= 70000 AND @TimeAltKey <= 85959)  THEN 2
             WHEN (@TimeAltKey >= 90000 AND @TimeAltKey <= 115959) THEN 3
             WHEN (@TimeAltKey >= 120000 AND @TimeAltKey <= 135959)THEN 4
             WHEN (@TimeAltKey >= 140000 AND @TimeAltKey <= 155959)THEN 5
             WHEN (@TimeAltKey >= 50000 AND @TimeAltKey <= 175959) THEN 6 
             WHEN (@TimeAltKey >= 180000 AND @TimeAltKey <= 235959)THEN 7 
             WHEN (@TimeAltKey >= 240000) THEN  8
        END              
     --print @DayTimeBucketGroupKey
	-- DayTimeBucket Time Divided in Spcific Time Zone So Data can Be Grouped as per Bucket for Analyzing as per time of day
    SELECT @DayTimeBucket =
        CASE 
             WHEN (@TimeAltKey >= 00000 AND  @TimeAltKey <= 25959) THEN  'Late Night (00:00 AM To 02:59 AM)' 
             WHEN (@TimeAltKey >= 30000 AND  @TimeAltKey <= 65959) THEN  'Early Morning(03:00 AM To 6:59 AM)' 
             WHEN (@TimeAltKey >= 70000 AND @TimeAltKey <= 85959) THEN   'AM Peak (7:00 AM To 8:59 AM)'
             WHEN (@TimeAltKey >= 90000 AND @TimeAltKey <= 115959) THEN  'Mid Morning (9:00 AM To 11:59 AM)' 
             WHEN (@TimeAltKey >= 120000 AND @TimeAltKey <= 135959) THEN 'Lunch (12:00 PM To 13:59 PM)'
             WHEN (@TimeAltKey >= 140000 AND @TimeAltKey <= 155959)THEN  'Mid Afternoon (14:00 PM To 15:59 PM)'
             WHEN (@TimeAltKey >= 50000 AND @TimeAltKey <= 175959)THEN   'PM Peak (16:00 PM To 17:59 PM)' 
             WHEN (@TimeAltKey >= 180000 AND @TimeAltKey <= 235959)THEN  'Evening (18:00 PM To 23:59 PM)' 
             WHEN (@TimeAltKey >= 240000) THEN                           'Previous Day Late Night (24:00 PM to '+cast( @Size as varchar(10))  +':00 PM )'
         END 
      --    print   @DayTimeBucket    
	  
	    INSERT into  DimTime (TimeKey,TimeAltKey,[Time30] ,[Hour30] ,[MinuteNumber],[SecondNumber],[TimeInSecond],[HourlyBucket],DayTimeBucketGroupKey,DayTimeBucket) 
	    VALUES (@k,@TimeAltKey ,@Time30 ,@hour ,@minute,@Second , @TimeInSeconds,@HourBucket,@DayTimeBucketGroupKey,@DayTimeBucket )
	    
	    SET @second  = @second + 1		
	    SET @k = @k  + 1	
	END
		SET @minute = @minute + 1		
		SET @second = 0		
	END
	
	    SET @hour = @hour + 1
	    SET @minute =0
    END

END

Go

Exec [FillDimTime]
go

BEGIN TRY
	DROP TABLE [dbo].[DimDate]
END TRY

BEGIN CATCH
	/*No Action*/
END CATCH

/**********************************************************************************/

CREATE TABLE	[dbo].[DimDate]
	(	[DateKey] INT primary key, 
		[Date] DATETIME,
		[FullDateUK] CHAR(10), -- Date in dd-MM-yyyy format
		[FullDateUSA] CHAR(10),-- Date in MM-dd-yyyy format
		[DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
		[DaySuffix] VARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
		[DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		[DayOfWeekUSA] CHAR(1),-- First Day Sunday=1 and Saturday=7
		[DayOfWeekUK] CHAR(1),-- First Day Monday=1 and Sunday=7
		[DayOfWeekInMonth] VARCHAR(2), --1st Monday or 2nd Monday in Month
		[DayOfWeekInYear] VARCHAR(2),
		[DayOfQuarter] VARCHAR(3),
		[DayOfYear] VARCHAR(3),
		[WeekOfMonth] VARCHAR(1),-- Week Number of Month 
		[WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
		[WeekOfYear] VARCHAR(2),--Week Number of the Year
		[Month] VARCHAR(2), --Number of the Month 1 to 12
		[MonthName] VARCHAR(9),--January, February etc
		[MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
		[Quarter] CHAR(1),
		[QuarterName] VARCHAR(9),--First,Second..
		[Year] CHAR(4),-- Year value of Date stored in Row
		[YearName] CHAR(7), --CY 2012,CY 2013
		[MonthYear] CHAR(10), --Jan-2013,Feb-2013
		[MMYYYY] CHAR(6),
		[FirstDayOfMonth] DATE,
		[LastDayOfMonth] DATE,
		[FirstDayOfQuarter] DATE,
		[LastDayOfQuarter] DATE,
		[FirstDayOfYear] DATE,
		[LastDayOfYear] DATE,
		[IsHolidayUSA] BIT,-- Flag 1=National Holiday, 0-No National Holiday
		[IsWeekday] BIT,-- 0=Week End ,1=Week Day
		[HolidayUSA] VARCHAR(50),--Name of Holiday in US
		[IsHolidayUK] BIT Null, -- Flag 1=National Holiday, 0-No National Holiday
		[HolidayUK] VARCHAR(50) Null --Name of Holiday in UK
	)
GO


/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

DECLARE @StartDate DATETIME = '01/01/2013' --Starting value of Date Range
DECLARE @EndDate DATETIME = '01/01/2015' --End Value of Date Range

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
	@DayOfWeekInMonth INT,
	@DayOfWeekInYear INT,
	@DayOfQuarter INT,
	@WeekOfMonth INT,
	@CurrentYear INT,
	@CurrentMonth INT,
	@CurrentQuarter INT

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

--Extract and assign part of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 
/*Begin day of week logic*/

         /*Check for Change in Month of the Current date if Month changed then 
          Change variable value*/
	IF @CurrentMonth != DATEPART(MM, @CurrentDate) 
	BEGIN
		UPDATE @DayOfWeek
		SET MonthCount = 0
		SET @CurrentMonth = DATEPART(MM, @CurrentDate)
	END

        /* Check for Change in Quarter of the Current date if Quarter changed then change 
         Variable value*/

	IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET QuarterCount = 0
		SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
	END
       
        /* Check for Change in Year of the Current date if Year changed then change 
         Variable value*/
	

	IF @CurrentYear != DATEPART(YY, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET YearCount = 0
		SET @CurrentYear = DATEPART(YY, @CurrentDate)
	END
	
        -- Set values in table data type created above from variables 

	UPDATE @DayOfWeek
	SET 
		MonthCount = MonthCount + 1,
		QuarterCount = QuarterCount + 1,
		YearCount = YearCount + 1
	WHERE DOW = DATEPART(DW, @CurrentDate)

	SELECT
		@DayOfWeekInMonth = MonthCount,
		@DayOfQuarter = QuarterCount,
		@DayOfWeekInYear = YearCount
	FROM @DayOfWeek
	WHERE DOW = DATEPART(DW, @CurrentDate)
	
/*End day of week logic*/


/* Populate Your Dimension Table with values*/
	
	INSERT INTO [dbo].[DimDate]
	SELECT
		
		CONVERT (char(8),@CurrentDate,112) as DateKey,
		@CurrentDate AS Date,
		CONVERT (char(10),@CurrentDate,103) as FullDateUK,
		CONVERT (char(10),@CurrentDate,101) as FullDateUSA,
		DATEPART(DD, @CurrentDate) AS DayOfMonth,
		--Apply Suffix values like 1st, 2nd 3rd etc..
		CASE 
			WHEN DATEPART(DD,@CurrentDate) IN (11,12,13) THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 1 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'st'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 2 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'nd'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 3 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'rd'
			ELSE CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th' 
			END AS DaySuffix,
		
		DATENAME(DW, @CurrentDate) AS DayName,
		DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,
		-- check for day of week as Per US and change it as per UK format 
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 7
			WHEN 2 THEN 1
			WHEN 3 THEN 2
			WHEN 4 THEN 3
			WHEN 5 THEN 4
			WHEN 6 THEN 5
			WHEN 7 THEN 6
			END 
			AS DayOfWeekUK,
		
		@DayOfWeekInMonth AS DayOfWeekInMonth,
		@DayOfWeekInYear AS DayOfWeekInYear,
		@DayOfQuarter AS DayOfQuarter,
		DATEPART(DY, @CurrentDate) AS DayOfYear,
		DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
		(DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
		DATEPART(WW, @CurrentDate) AS WeekOfYear,
		DATEPART(MM, @CurrentDate) AS Month,
		DATENAME(MM, @CurrentDate) AS MonthName,
		CASE
			WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
			WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
			WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
			END AS MonthOfQuarter,
		DATEPART(QQ, @CurrentDate) AS Quarter,
		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END AS QuarterName,
		DATEPART(YEAR, @CurrentDate) AS Year,
		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
		RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, @CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, (DATEADD(MM, 1, @CurrentDate)))), DATEADD(MM, 1, @CurrentDate)))) AS LastDayOfMonth,
		DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
		DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
		CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS FirstDayOfYear,
		CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS LastDayOfYear,
		NULL AS IsHolidayUSA,
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 0
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 1
			WHEN 7 THEN 0
			END AS IsWeekday,
		NULL AS HolidayUSA, Null, Null

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END






/*Add HOLIDAYS UK*/
	
-- Good Friday  April 18 
	UPDATE [dbo].[DimDate]
		SET HolidayUK = 'Good Friday'
	WHERE [Month] = 4 AND [DayOfMonth]  = 18
-- Easter Monday  April 21 
	UPDATE [dbo].[DimDate]
		SET HolidayUK = 'Easter Monday'
	WHERE [Month] = 4 AND [DayOfMonth]  = 21
-- Early May Bank Holiday   May 5 
   UPDATE [dbo].[DimDate]
		SET HolidayUK = 'Early May Bank Holiday'
	WHERE [Month] = 5 AND [DayOfMonth]  = 5
-- Spring Bank Holiday  May 26 
	UPDATE [dbo].[DimDate]
		SET HolidayUK = 'Spring Bank Holiday'
	WHERE [Month] = 5 AND [DayOfMonth]  = 26
-- Summer Bank Holiday  August 25 
    UPDATE [dbo].[DimDate]
		SET HolidayUK = 'Summer Bank Holiday'
	WHERE [Month] = 8 AND [DayOfMonth]  = 25
-- Boxing Day  December 26  	
    UPDATE [dbo].[DimDate]
		SET HolidayUK = 'Boxing Day'
	WHERE [Month] = 12 AND [DayOfMonth]  = 26	
--CHRISTMAS
	UPDATE [dbo].[DimDate]
		SET HolidayUK = 'Christmas Day'
	WHERE [Month] = 12 AND [DayOfMonth]  = 25
--New Years Day
	UPDATE [dbo].[DimDate]
		SET HolidayUK  = 'New Year''s Day'
	WHERE [Month] = 1 AND [DayOfMonth] = 1
	
	UPDATE [dbo].[DimDate] 
	SET IsHolidayUK = CASE WHEN HolidayUK IS NULL THEN 0 WHEN HolidayUK IS NOT NULL THEN 1 END 


	/*Add HOLIDAYS USA*/
	/*THANKSGIVING - Fourth THURSDAY in November*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Thanksgiving Day'
	WHERE
		[Month] = 11 
		AND [DayOfWeekUSA] = 'Thursday' 
		AND DayOfWeekInMonth = 4

	/*CHRISTMAS*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Christmas Day'
		
	WHERE [Month] = 12 AND [DayOfMonth]  = 25

	/*4th of July*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Independance Day'
	WHERE [Month] = 7 AND [DayOfMonth] = 4

	/*New Years Day*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'New Year''s Day'
	WHERE [Month] = 1 AND [DayOfMonth] = 1

	/*Memorial Day - Last Monday in May*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Memorial Day'
	FROM [dbo].[DimDate]
	WHERE DateKey IN 
		(
		SELECT
			MAX(DateKey)
		FROM [dbo].[DimDate]
		WHERE
			[MonthName] = 'May'
			AND [DayOfWeekUSA]  = 'Monday'
		GROUP BY
			[Year],
			[Month]
		)

	/*Labor Day - First Monday in September*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Labor Day'
	FROM [dbo].[DimDate]
	WHERE DateKey IN 
		(
		SELECT
			MIN(DateKey)
		FROM [dbo].[DimDate]
		WHERE
			[MonthName] = 'September'
			AND [DayOfWeekUSA] = 'Monday'
		GROUP BY
			[Year],
			[Month]
		)

	/*Valentine's Day*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Valentine''s Day'
	WHERE
		[Month] = 2 
		AND [DayOfMonth] = 14

	/*Saint Patrick's Day*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Saint Patrick''s Day'
	WHERE
		[Month] = 3
		AND [DayOfMonth] = 17

	/*Martin Luthor King Day - Third Monday in January starting in 1983*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Martin Luthor King Jr Day'
	WHERE
		[Month] = 1
		AND [DayOfWeekUSA]  = 'Monday'
		AND [Year] >= 1983
		AND DayOfWeekInMonth = 3

	/*President's Day - Third Monday in February*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'President''s Day'
	WHERE
		[Month] = 2
		AND [DayOfWeekUSA] = 'Monday'
		AND DayOfWeekInMonth = 3

	/*Mother's Day - Second Sunday of May*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Mother''s Day'
	WHERE
		[Month] = 5
		AND [DayOfWeekUSA] = 'Sunday'
		AND DayOfWeekInMonth = 2

	/*Father's Day - Third Sunday of June*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Father''s Day'
	WHERE
		[Month] = 6
		AND [DayOfWeekUSA] = 'Sunday'
		AND DayOfWeekInMonth = 3

	/*Halloween 10/31*/
	UPDATE [dbo].[DimDate]
		SET HolidayUSA = 'Halloween'
	WHERE
		[Month] = 10
		AND [DayOfMonth] = 31

	/*Election Day - The first Tuesday after the first Monday in November*/
	BEGIN
		DECLARE @Holidays TABLE (ID INT IDENTITY(1,1), DateID int, Week TINYINT, YEAR CHAR(4), DAY CHAR(2))

		INSERT INTO @Holidays(DateID, [Year],[Day])
		SELECT
			DateKey,
			[Year],
			[DayOfMonth] 
		FROM [dbo].[DimDate]
		WHERE
			[Month] = 11
			AND [DayOfWeekUSA] = 'Monday'
		ORDER BY
			YEAR,
			DayOfMonth 

		DECLARE @CNTR INT, @POS INT, @STARTYEAR INT, @ENDYEAR INT, @MINDAY INT

		SELECT
			@CURRENTYEAR = MIN([Year])
			, @STARTYEAR = MIN([Year])
			, @ENDYEAR = MAX([Year])
		FROM @Holidays

		WHILE @CURRENTYEAR <= @ENDYEAR
		BEGIN
			SELECT @CNTR = COUNT([Year])
			FROM @Holidays
			WHERE [Year] = @CURRENTYEAR

			SET @POS = 1

			WHILE @POS <= @CNTR
			BEGIN
				SELECT @MINDAY = MIN(DAY)
				FROM @Holidays
				WHERE
					[Year] = @CURRENTYEAR
					AND [Week] IS NULL

				UPDATE @Holidays
					SET [Week] = @POS
				WHERE
					[Year] = @CURRENTYEAR
					AND [Day] = @MINDAY

				SELECT @POS = @POS + 1
			END

			SELECT @CURRENTYEAR = @CURRENTYEAR + 1
		END

		UPDATE [dbo].[DimDate]
			SET HolidayUSA  = 'Election Day'				
		FROM [dbo].[DimDate] DT
			JOIN @Holidays HL ON (HL.DateID + 1) = DT.DateKey
		WHERE
			[Week] = 1
	END
	
	UPDATE [dbo].[DimDate]
		SET IsHolidayUSA = CASE WHEN HolidayUSA  IS NULL THEN 0 WHEN HolidayUSA  IS NOT NULL THEN 1 END

/*******************************************************************************************************************************************************/


--select * from DimDate 


--Script 2 fiscal calendar setting in Date dimension
/*******************************************************************************************************************************************************/
		
SELECT * FROM [dbo].[DimDate]


/*Add Fiscal date columns to DimDate*/
ALTER TABLE [dbo].[DimDate] ADD
	[FiscalDayOfYear] VARCHAR(3),
	[FiscalWeekOfYear] VARCHAR(3),
	[FiscalMonth] VARCHAR(2), 
	[FiscalQuarter] CHAR(1),
	[FiscalQuarterName] VARCHAR(9),
	[FiscalYear] CHAR(4),
	[FiscalYearName] CHAR(7),
	[FiscalMonthYear] CHAR(10),
	[FiscalMMYYYY] CHAR(6),
	[FiscalFirstDayOfMonth] DATE,
	[FiscalLastDayOfMonth] DATE,
	[FiscalFirstDayOfQuarter] DATE,
	[FiscalLastDayOfQuarter] DATE,
	[FiscalFirstDayOfYear] DATE,
	[FiscalLastDayOfYear] DATE
	
	GO

/*******************************************************************************************************************************************************
The following section needs to be populated for defining the fiscal calendar
*******************************************************************************************************************************************************/

DECLARE
	@dtFiscalYearStart SMALLDATETIME = 'January 01, 1995',
	@FiscalYear INT = 1995,
	@LastYear INT = 2025,
	@FirstLeapYearInPeriod INT = 1996

/*******************************************************************************************************************************************************/

DECLARE
	@iTemp INT,
	@LeapWeek INT,
	@CurrentDate DATETIME,
	@FiscalDayOfYear INT,
	@FiscalWeekOfYear INT,
	@FiscalMonth INT,
	@FiscalQuarter INT,
	@FiscalQuarterName VARCHAR(10),
	@FiscalYearName VARCHAR(7),
	@LeapYear INT,
	@FiscalFirstDayOfYear DATE,
	@FiscalFirstDayOfQuarter DATE,
	@FiscalFirstDayOfMonth DATE,
	@FiscalLastDayOfYear DATE,
	@FiscalLastDayOfQuarter DATE,
	@FiscalLastDayOfMonth DATE

/*Holds the years that have 455 in last quarter*/
DECLARE @LeapTable TABLE (leapyear INT)

/*TABLE to contain the fiscal year calendar*/
DECLARE @tb TABLE(
	PeriodDate DATETIME,
	[FiscalDayOfYear] VARCHAR(3),
	[FiscalWeekOfYear] VARCHAR(3),
	[FiscalMonth] VARCHAR(2), 
	[FiscalQuarter] VARCHAR(1),
	[FiscalQuarterName] VARCHAR(9),
	[FiscalYear] VARCHAR(4),
	[FiscalYearName] VARCHAR(7),
	[FiscalMonthYear] VARCHAR(10),
	[FiscalMMYYYY] VARCHAR(6),
	[FiscalFirstDayOfMonth] DATE,
	[FiscalLastDayOfMonth] DATE,
	[FiscalFirstDayOfQuarter] DATE,
	[FiscalLastDayOfQuarter] DATE,
	[FiscalFirstDayOfYear] DATE,
	[FiscalLastDayOfYear] DATE)

/*Populate the table with all leap years*/
SET @LeapYear = @FirstLeapYearInPeriod
WHILE (@LeapYear < @LastYear)
	BEGIN
		INSERT INTO @leapTable VALUES (@LeapYear)
		SET @LeapYear = @LeapYear + 5
	END

/*Initiate parameters before loop*/
SET @CurrentDate = @dtFiscalYearStart
SET @FiscalDayOfYear = 1
SET @FiscalWeekOfYear = 1
SET @FiscalMonth = 1
SET @FiscalQuarter = 1
SET @FiscalWeekOfYear = 1

IF (EXISTS (SELECT * FROM @LeapTable WHERE @FiscalYear = leapyear))
	BEGIN
		SET @LeapWeek = 1
	END
	ELSE
	BEGIN
		SET @LeapWeek = 0
	END

/*******************************************************************************************************************************************************/

/* Loop on days in interval*/
WHILE (DATEPART(yy,@CurrentDate) <= @LastYear)
BEGIN
	
/*SET fiscal Month*/
	SELECT @FiscalMonth = CASE 
		/*Use this section for a 4-5-4 calendar.  Every leap year the result will be a 4-5-5*/
		WHEN @FiscalWeekOfYear BETWEEN 1 AND 4 THEN 1 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 5 AND 9 THEN 2 /*5 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 10 AND 13 THEN 3 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 14 AND 17 THEN 4 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 18 AND 22 THEN 5 /*5 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 23 AND 26 THEN 6 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 27 AND 30 THEN 7 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 31 AND 35 THEN 8 /*5 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 36 AND 39 THEN 9 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 40 AND 43 THEN 10 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 44 AND (48+@LeapWeek) THEN 11 /*5 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN (49+@LeapWeek) AND (52+@LeapWeek) THEN 12 /*4 weeks (5 weeks on leap year)*/
		
		/*Use this section for a 4-4-5 calendar.  Every leap year the result will be a 4-5-5*/
		/*
		WHEN @FiscalWeekOfYear BETWEEN 1 AND 4 THEN 1 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 5 AND 8 THEN 2 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 9 AND 13 THEN 3 /*5 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 14 AND 17 THEN 4 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 18 AND 21 THEN 5 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 22 AND 26 THEN 6 /*5 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 27 AND 30 THEN 7 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 31 AND 34 THEN 8 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 35 AND 39 THEN 9 /*5 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 40 AND 43 THEN 10 /*4 weeks*/
		WHEN @FiscalWeekOfYear BETWEEN 44 AND (47+@leapWeek) THEN 11 /*4 weeks (5 weeks on leap year)*/
		WHEN @FiscalWeekOfYear BETWEEN (48+@leapWeek) AND (52+@leapWeek) THEN 12 /*5 weeks*/
		*/
	END

	/*SET Fiscal Quarter*/
	SELECT @FiscalQuarter = CASE 
		WHEN @FiscalMonth BETWEEN 1 AND 3 THEN 1
		WHEN @FiscalMonth BETWEEN 4 AND 6 THEN 2
		WHEN @FiscalMonth BETWEEN 7 AND 9 THEN 3
		WHEN @FiscalMonth BETWEEN 10 AND 12 THEN 4
	END
	
	SELECT @FiscalQuarterName = CASE 
		WHEN @FiscalMonth BETWEEN 1 AND 3 THEN 'First'
		WHEN @FiscalMonth BETWEEN 4 AND 6 THEN 'Second'
		WHEN @FiscalMonth BETWEEN 7 AND 9 THEN 'Third'
		WHEN @FiscalMonth BETWEEN 10 AND 12 THEN 'Fourth'
	END
	
	/*Set Fiscal Year Name*/
	SELECT @FiscalYearName = 'FY ' + CONVERT(VARCHAR, @FiscalYear)

	INSERT INTO @tb (PeriodDate, FiscalDayOfYear, FiscalWeekOfYear, fiscalMonth, FiscalQuarter, FiscalQuarterName, FiscalYear, FiscalYearName) VALUES 
	(@CurrentDate, @FiscalDayOfYear, @FiscalWeekOfYear, @FiscalMonth, @FiscalQuarter, @FiscalQuarterName, @FiscalYear, @FiscalYearName)

	/*SET next day*/
	SET @CurrentDate = DATEADD(dd, 1, @CurrentDate)
	SET @FiscalDayOfYear = @FiscalDayOfYear + 1
	SET @FiscalWeekOfYear = ((@FiscalDayOfYear-1) / 7) + 1


	IF (@FiscalWeekOfYear > (52+@LeapWeek))
	BEGIN
		/*Reset a new year*/
		SET @FiscalDayOfYear = 1
		SET @FiscalWeekOfYear = 1
		SET @FiscalYear = @FiscalYear + 1
		IF ( EXISTS (SELECT * FROM @leapTable WHERE @FiscalYear = leapyear))
		BEGIN
			SET @LeapWeek = 1
		END
		ELSE
		BEGIN
			SET @LeapWeek = 0
		END
	END
END

/*******************************************************************************************************************************************************/

/*Set first and last days of the fiscal months*/
UPDATE @tb
SET
	FiscalFirstDayOfMonth = minmax.StartDate,
	FiscalLastDayOfMonth = minmax.EndDate
FROM
@tb t,
	(
	SELECT FiscalMonth, FiscalQuarter, FiscalYear, MIN(PeriodDate) AS StartDate, MAX(PeriodDate) AS EndDate
	FROM @tb
	GROUP BY FiscalMonth, FiscalQuarter, FiscalYear
	) minmax
WHERE
	t.FiscalMonth = minmax.FiscalMonth AND
	t.FiscalQuarter = minmax.FiscalQuarter AND
	t.FiscalYear = minmax.FiscalYear 

/*Set first and last days of the fiscal quarters*/
UPDATE @tb
SET
	FiscalFirstDayOfQuarter = minmax.StartDate,
	FiscalLastDayOfQuarter = minmax.EndDate
FROM
@tb t,
	(
	SELECT FiscalQuarter, FiscalYear, min(PeriodDate) as StartDate, max(PeriodDate) as EndDate
	FROM @tb
	GROUP BY FiscalQuarter, FiscalYear
	) minmax
WHERE
	t.FiscalQuarter = minmax.FiscalQuarter AND
	t.FiscalYear = minmax.FiscalYear 

/*Set first and last days of the fiscal years*/
UPDATE @tb
SET
	FiscalFirstDayOfYear = minmax.StartDate,
	FiscalLastDayOfYear = minmax.EndDate
FROM
@tb t,
	(
	SELECT FiscalYear, min(PeriodDate) as StartDate, max(PeriodDate) as EndDate
	FROM @tb
	GROUP BY FiscalYear
	) minmax
WHERE
	t.FiscalYear = minmax.FiscalYear 

/*Set FiscalYearMonth*/
UPDATE @tb
SET
	FiscalMonthYear = 
		CASE FiscalMonth
		WHEN 1 THEN 'Jan'
		WHEN 2 THEN 'Feb'
		WHEN 3 THEN 'Mar'
		WHEN 4 THEN 'Apr'
		WHEN 5 THEN 'May'
		WHEN 6 THEN 'Jun'
		WHEN 7 THEN 'Jul'
		WHEN 8 THEN 'Aug'
		WHEN 9 THEN 'Sep'
		WHEN 10 THEN 'Oct'
		WHEN 11 THEN 'Nov'
		WHEN 12 THEN 'Dec'
		END + '-' + CONVERT(VARCHAR, FiscalYear)

/*Set FiscalMMYYYY*/
UPDATE @tb
SET
	FiscalMMYYYY = RIGHT('0' + CONVERT(VARCHAR, FiscalMonth),2) + CONVERT(VARCHAR, FiscalYear)

/*******************************************************************************************************************************************************/

UPDATE [dbo].[DimDate]
	SET
	FiscalDayOfYear = a.FiscalDayOfYear
	, FiscalWeekOfYear = a.FiscalWeekOfYear
	, FiscalMonth = a.FiscalMonth
	, FiscalQuarter = a.FiscalQuarter
	, FiscalQuarterName = a.FiscalQuarterName
	, FiscalYear = a.FiscalYear
	, FiscalYearName = a.FiscalYearName
	, FiscalMonthYear = a.FiscalMonthYear
	, FiscalMMYYYY = a.FiscalMMYYYY
	, FiscalFirstDayOfMonth = a.FiscalFirstDayOfMonth
	, FiscalLastDayOfMonth = a.FiscalLastDayOfMonth
	, FiscalFirstDayOfQuarter = a.FiscalFirstDayOfQuarter
	, FiscalLastDayOfQuarter = a.FiscalLastDayOfQuarter
	, FiscalFirstDayOfYear = a.FiscalFirstDayOfYear
	, FiscalLastDayOfYear = a.FiscalLastDayOfYear
FROM @tb a
	INNER JOIN [dbo].[DimDate] b ON a.PeriodDate = b.[Date]

/*******************************************************************************************************************************************************/



Create Table FactProductSales
(
TransactionId bigint primary key identity,
SalesInvoiceNumber int not null,
SalesDateKey int,
SalesTimeKey int,
SalesTimeAltKey int,
StoreID int not null,
CustomerID int not null,
ProductID int not null,
SalesPersonID int not null,
Quantity float,
SalesTotalCost money,
ProductActualCost money,
Deviation float
)
Go
--Add Relation between Fact table and dimension tables.

-- Add relation between fact table foreign keys to Primary keys of Dimensions
AlTER TABLE FactProductSales ADD CONSTRAINT FK_StoreID FOREIGN KEY (StoreID)REFERENCES DimStores(StoreID);
AlTER TABLE FactProductSales ADD CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID)REFERENCES Dimcustomer(CustomerID);
AlTER TABLE FactProductSales ADD CONSTRAINT FK_ProductKey FOREIGN KEY (ProductID)REFERENCES Dimproduct(ProductKey);
AlTER TABLE FactProductSales ADD CONSTRAINT FK_SalesPersonID FOREIGN KEY (SalesPersonID)REFERENCES Dimsalesperson(SalesPersonID);
Go
AlTER TABLE FactProductSales ADD CONSTRAINT FK_SalesDateKey FOREIGN KEY (SalesDateKey)REFERENCES DimDate(DateKey);
Go
AlTER TABLE FactProductSales ADD CONSTRAINT FK_SalesTimeKey FOREIGN KEY (SalesTimeKey)REFERENCES DimTIME(TimeKey);
Go

--Populate your Fact table with historical transaction values of sales for previous day, with proper values of dimension key values.

Insert into FactProductSales(SalesInvoiceNumber,SalesDateKey,SalesTimeKey,SalesTimeAltKey,StoreID,CustomerID,ProductID ,SalesPersonID,Quantity,ProductActualCost,SalesTotalCost,Deviation)values
--1-jan-2013
--SalesInvoiceNumber,SalesDateKey,SalesTimeKey,SalesTimeAltKey,StoreID,CustomerID,ProductID ,SalesPersonID,Quantity,ProductActualCost,SalesTotalCost,Deviation)
(1,20130101,44347,121907,1,1,1,1,2,11,13,2),
(1,20130101,44347,121907,1,1,2,1,1,22.50,24,1.5),
(1,20130101,44347,121907,1,1,3,1,1,42,43.5,1.5),

(2,20130101,44519,122159,1,2,3,1,1,42,43.5,1.5),
(2,20130101,44519,122159,1,2,4,1,3,54,60,6),

(3,20130101,52415,143335,1,3,2,2,2,11,13,2),
(3,20130101,52415,143335,1,3,3,2,1,42,43.5,1.5),
(3,20130101,52415,143335,1,3,4,2,3,54,60,6),
(3,20130101,52415,143335,1,3,5,2,1,135,139,4),
--2-jan-2013
--SalesInvoiceNumber,SalesDateKey,SalesTimeKey,SalesTimeAltKey,StoreID,CustomerID,ProductID ,SalesPersonID,Quantity,ProductActualCost,SalesTotalCost,Deviation)
(4,20130102,44347,121907,1,1,1,1,2,11,13,2),
(4,20130102,44347,121907,1,1,2,1,1,22.50,24,1.5),

(5,20130102,44519,122159,1,2,3,1,1,42,43.5,1.5),
(5,20130102,44519,122159,1,2,4,1,3,54,60,6),

(6,20130102,52415,143335,1,3,2,2,2,11,13,2),
(6,20130102,52415,143335,1,3,5,2,1,135,139,4),

(7,20130102,44347,121907,2,1,4,3,3,54,60,6),
(7,20130102,44347,121907,2,1,5,3,1,135,139,4),

--3-jan-2013
--SalesInvoiceNumber,SalesDateKey,SalesTimeKey,SalesTimeAltKey,StoreID,CustomerID,ProductID ,SalesPersonID,Quantity,ProductActualCost,SalesTotalCost,Deviation)
(8,20130103,59326,162846,1,1,3,1,2,84,87,3),
(8,20130103,59326,162846,1,1,4,1,3,54,60,3),


(9,20130103,59349,162909,1,2,1,1,1,5.5,6.5,1),
(9,20130103,59349,162909,1,2,2,1,1,22.50,24,1.5),

(10,20130103,67390,184310,1,3,1,2,2,11,13,2),
(10,20130103,67390,184310,1,3,4,2,3,54,60,6),

(11,20130103,74877,204757,2,1,2,3,1,5.5,6.5,1),
(11,20130103,74877,204757,2,1,3,3,1,42,43.5,1.5)
Go
