
-- LOAD THE MARKING SCRIPT DEPENDENCIES

@./A1M_Installer_Includes/a1m_Check_If_Attempted.sql;
@./A1M_Installer_Includes/a1m_Database_Reset.sql;
EXECUTE A1M_DATABASE_RESET;
@./A1M_Installer_Includes/a1m_PREMARK_CHECK.sql;
EXECUTE A1M_PREMARK_CHECK;

-- LOAD THE INDIVDUAL MARKING FUNCTIONS

@./A1M_Installer_Includes/a1m_Add_Customer_To_Db.sql;
@./A1M_Installer_Includes/a1m_Delete_All_Cust_From_Db.sql;
@./A1M_Installer_Includes/a1m_Add_Product_To_Db.sql;
@./A1M_Installer_Includes/a1m_Delete_All_Prod_From_Db.sql;
@./A1M_Installer_Includes/a1m_Get_Cust_String_From_Db.sql;
@./A1M_Installer_Includes/a1m_Upd_Cust_Salesytd_In_Db.sql;
@./A1M_Installer_Includes/a1m_Get_Prod_String_From_Db.sql;
@./A1M_Installer_Includes/a1m_Upd_Prod_Salesytd_In_Db.sql;
@./A1M_Installer_Includes/a1m_upd_Cust_Status_in_Db.sql;
@./A1M_Installer_Includes/a1m_ADD_SIMPLE_SALE_TO_DB.sql;
@./A1M_Installer_Includes/a1m_SUM_CUST_SALESYTD_FROM_DB.sql;
@./A1M_Installer_Includes/a1m_SUM_PROD_SALESYTD_FROM_DB.sql;
@./A1M_Installer_Includes/a1m_GET_ALLCUST_FROM_DB.sql;
@./A1M_Installer_Includes/a1m_GET_ALLPROD_FROM_DB.sql;
@./A1M_Installer_Includes/a1m_ADD_LOCATION_TO_DB.sql;
@./A1M_Installer_Includes/a1m_ADD_COMPLEX_SALE_TO_DB.sql;
@./A1M_Installer_Includes/a1m_Get_Allsales_From_Db.sql;
@./A1M_Installer_Includes/A1M_COUNT_PRODUCT_SALES_FROM_DB.sql;
@./A1M_Installer_Includes/A1M_DELETE_SALE_FROM_DB.sql;
@./A1M_Installer_Includes/A1M_DELETE_ALL_SALES_FROM_DB.sql;
@./A1M_Installer_Includes/A1M_DELETE_CUSTOMER_FROM_DB.sql;
@./A1M_Installer_Includes/A1M_DELETE_PROD_FROM_DB.sql;

-- LOAD THE MAGIC MAIN MARKING SCRIPT TO BRING IT ALL TOGETHER

@./A1M_Installer_Includes/A1M_MARK_DBSYS_ASS1.sql;

-- set up synonyms for student access
begin
EXECUTE IMMEDIATE 'drop public synonym A1M_DATABASE_RESET';
EXECUTE IMMEDIATE 'create public synonym A1M_DATABASE_RESET  for ' || USER || '.A1M_DATABASE_RESET';

EXECUTE IMMEDIATE 'drop public synonym A1m_Mark_Dbsys_Ass1';
EXECUTE IMMEDIATE 'create public synonym A1m_Mark_Dbsys_Ass1  for ' || USER || '.A1m_Mark_Dbsys_Ass1';
end;
/

-- set up the permissions needed for students to access script
GRANT EXECUTE ON A1M_MARK_DBSYS_ASS1 TO PUBLIC;
GRANT EXECUTE ON A1M_DATABASE_RESET TO PUBLIC;

COMMIT;
