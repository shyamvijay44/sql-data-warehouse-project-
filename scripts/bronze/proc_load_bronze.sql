/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from CSV files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE PROCEDURE bronze.load_bronze 
AS 
BEGIN

DECLARE 
    @start_time DATETIME,
    @end_time DATETIME,
    @batchstart_time DATETIME,
    @batchend_time DATETIME;

BEGIN TRY

    SET @batchstart_time = GETDATE();

    PRINT '=========================================';
    PRINT 'Loading Bronze Layer';
    PRINT '=========================================';

    -----------------------------------
    -- CRM TABLES
    -----------------------------------
    PRINT 'Loading CRM Tables';

    -- crm_cust_info
    SET @start_time = GETDATE();
    PRINT 'Truncating bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;

    PRINT 'Inserting bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info
    FROM 'C:\Users\Shyam Vijay\Documents\vs\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    SET @end_time = GETDATE();
    PRINT 'Load Time: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' sec';

    -----------------------------------
    -- crm_prd_info
    -----------------------------------
    SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.crm_prd_info;

    BULK INSERT bronze.crm_prd_info
    FROM 'C:\Users\Shyam Vijay\Documents\vs\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    SET @end_time = GETDATE();
    PRINT 'Load Time: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' sec';

    -----------------------------------
    -- crm_sales_details
    -----------------------------------
    SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.crm_sales_details;

    BULK INSERT bronze.crm_sales_details
    FROM 'C:\Users\Shyam Vijay\Documents\vs\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    SET @end_time = GETDATE();
    PRINT 'Load Time: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' sec';

    -----------------------------------
    -- ERP TABLES
    -----------------------------------
    PRINT 'Loading ERP Tables';

    -- erp_cust_az12
    SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.erp_cust_az12;

    BULK INSERT bronze.erp_cust_az12
    FROM 'C:\Users\Shyam Vijay\Documents\vs\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    SET @end_time = GETDATE();
    PRINT 'Load Time: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' sec';

    -- erp_loc_a101
    SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.erp_loc_a101;

    BULK INSERT bronze.erp_loc_a101
    FROM 'C:\Users\Shyam Vijay\Documents\vs\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    SET @end_time = GETDATE();
    PRINT 'Load Time: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' sec';

    -- erp_px_cat_g1v2
    SET @start_time = GETDATE();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    BULK INSERT bronze.erp_px_cat_g1v2
    FROM 'C:\Users\Shyam Vijay\Documents\vs\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );

    SET @end_time = GETDATE();
    PRINT 'Load Time: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' sec';

    -----------------------------------
    -- Batch Time
    -----------------------------------
    SET @batchend_time = GETDATE();
    PRINT 'Total Load Time: ' + CAST(DATEDIFF(SECOND,@batchstart_time,@batchend_time) AS NVARCHAR) + ' sec';

END TRY

BEGIN CATCH
    PRINT 'Error occurred during loading bronze layer';
    PRINT ERROR_MESSAGE();
    PRINT CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT CAST(ERROR_STATE() AS NVARCHAR);
END CATCH

END;
