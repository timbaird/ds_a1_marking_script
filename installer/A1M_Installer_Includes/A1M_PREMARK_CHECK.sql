
-- CHECKS FOR ANY FUNCTIONS THAT DO NOT EXIST
-- ADD AND ENTRY TO THE Not_Attempted TABLE
-- CREATED A DUMMY FUNCTION SO MARKING SCRIPTS WILL STILL WORK.

CREATE OR REPLACE PROCEDURE A1M_PREMARK_CHECK AUTHID CURRENT_USER AS

BEGIN

  If A1m_Check_If_Attempted('ADD_CUST_TO_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('ADD_CUST_TO_DB');
  
  
    Execute Immediate '
    CREATE OR REPLACE PROCEDURE ADD_CUST_TO_DB(
                                     pCustId CUSTOMER.CUSTID%TYPE,
                                     pCustName CUSTOMER.CUSTNAME%TYPE ) AS
    BEGIN
      dbms_output.put_line(''DUMMY FUNCTION'');
    END;
    ';
    
  END IF;
  

  If A1m_Check_If_Attempted('DELETE_ALL_CUSTOMERS_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('DELETE_ALL_CUSTOMERS_FROM_DB');
  
    Execute Immediate '
    CREATE OR REPLACE FUNCTION DELETE_ALL_CUSTOMERS_FROM_DB RETURN NUMBER AS

    BEGIN
      -- DUMMY FUNCTION
      return 999999999999999;
    END;
    ';
    
  End If;



  If A1m_Check_If_Attempted('ADD_PROD_TO_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('ADD_PROD_TO_DB');
  
    Execute Immediate '
    CREATE OR REPLACE PROCEDURE ADD_PROD_TO_DB(   pProdId PRODUCT.PRODID%TYPE, 
                                                 pProdName PRODUCT.PRODNAME%TYPE, 
                                                 pPrice PRODUCT.SELLING_PRICE%TYPE )  AS
    BEGIN
      dbms_output.put_line(''DUMMY FUNCTION'');
    END;
    ';
    
  End If;



  If A1m_Check_If_Attempted('DELETE_ALL_PRODUCTS_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('DELETE_ALL_PRODUCTS_FROM_DB');
  
    Execute Immediate '
    CREATE OR REPLACE FUNCTION DELETE_ALL_PRODUCTS_FROM_DB RETURN NUMBER AS

    BEGIN
      -- DUMMY FUNCTION
      return 999999999999999;
    END;
    ';


  End If;


  
  If A1m_Check_If_Attempted('GET_CUST_STRING_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('GET_CUST_STRING_FROM_DB');
  
    Execute Immediate '
    CREATE OR REPLACE FUNCTION GET_CUST_STRING_FROM_DB(pCustId CUSTOMER.CUSTID%TYPE) RETURN VARCHAR2 AS
    BEGIN
      RETURN ''DUMMY FUNCTION'';
    END;
    ';

  End If;
  


  If A1m_Check_If_Attempted('UPD_CUST_SALESYTD_IN_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('UPD_CUST_SALESYTD_IN_DB');
  
    Execute Immediate '
    CREATE OR REPLACE PROCEDURE UPD_CUST_SALESYTD_IN_DB(  
                                            pCustId CUSTOMER.CUSTID%TYPE,
                                            pAmt CUSTOMER.SALES_YTD%TYPE
                                                    ) AS
    BEGIN
      dbms_output.put_line( ''DUMMY PROCEDURE'');
    END;
    ';

  End If;
  

  If A1m_Check_If_Attempted('GET_PROD_STRING_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('GET_PROD_STRING_FROM_DB');
  
    Execute Immediate '
    CREATE OR REPLACE FUNCTION GET_PROD_STRING_FROM_DB(pProdId PRODUCT.PRODID%TYPE) RETURN VARCHAR2 AS
    BEGIN
      RETURN ''DUMMY PROCEDURE'';
    END;
    ';

  End If;
  
  If A1m_Check_If_Attempted('UPD_PROD_SALESYTD_IN_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('UPD_PROD_SALESYTD_IN_DB');
  
    Execute Immediate '
    CREATE OR REPLACE PROCEDURE UPD_PROD_SALESYTD_IN_DB(  
                                            pProdId PRODUCT.PRODID%TYPE,
                                            Pamt Product.Sales_Ytd%Type
                                                    ) AS
    BEGIN
      dbms_output.put_line( ''DUMMY PROCEDURE'');
    END;
    ';

  End If; 
  
  If A1m_Check_If_Attempted('UPD_CUST_STATUS_IN_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('UPD_CUST_STATUS_IN_DB');
  
    Execute Immediate '
    Create Or Replace Procedure Upd_Cust_Status_In_Db(
                                                  Pcustid Customer.Custid%Type,
                                                  Pstatus Customer.Status%Type
                                                  )  as
    BEGIN
      dbms_output.put_line( ''DUMMY PROCEDURE'');
    END;
    ';

  End If;
  

  If A1m_Check_If_Attempted('ADD_SIMPLE_SALE_TO_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('ADD_SIMPLE_SALE_TO_DB');
  
    Execute Immediate '
    Create Or Replace Procedure ADD_SIMPLE_SALE_TO_DB(
                                                  Pcustid Customer.Custid%Type,
                                                  Pprodid Product.Prodid%Type,
                                                  Pqty Number
                                                  ) as
    BEGIN
      dbms_output.put_line( ''DUMMY PROCEDURE'');
    END;
    ';

  End If; 
  
  If A1m_Check_If_Attempted('SUM_CUST_SALESYTD') = False Then

    Insert Into Not_Attempted (Fname) Values ('SUM_CUST_SALESYTD');
  
    Execute Immediate '
    create or replace function SUM_CUST_SALESYTD return number as
    
    BEGIN
      -- DUMMY FUNCTION
      RETURN 999999999999999;
    END;
    ';

  End If; 
  
    If A1m_Check_If_Attempted('SUM_PROD_SALESYTD_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('SUM_PROD_SALESYTD_FROM_DB');
  
    Execute Immediate '
    create or replace function SUM_PROD_SALESYTD_FROM_DB return number as 
    
    BEGIN
      -- DUMMY FUNCTION
      RETURN 999999999999999;
    END;
    ';

  End If; 
    

--  START ON TASK 2 FUNCTIONS


  
  If A1m_Check_If_Attempted('GET_ALLCUST') = False Then

    Insert Into Not_Attempted (Fname) Values ('GET_ALLCUST');
  
    Execute Immediate '
    create or replace function GET_ALLCUST return sys_refcursor as
      Vcur Sys_Refcursor;
    begin
      OPEN VcUR FOR SELECT * FROM CUSTOMER WHERE CUSTID = 5000;
      RETURN VCUR;
    exception
      WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, SQLERRM);
    End;

    ';

  End If; 


  If A1m_Check_If_Attempted('GET_ALLPROD_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('GET_ALLPROD_FROM_DB');
  
    Execute Immediate '
    create or replace function GET_ALLPROD_FROM_DB return sys_refcursor as
      Vcur Sys_Refcursor;
    begin
      OPEN VcUR FOR SELECT * FROM PRODUCT WHERE PRODID = 50000;
      RETURN VCUR;
    exception
      WHEN OTHERS THEN
      Raise_Application_Error(-20000, Sqlerrm);
    End;
    ';

  End If; 
  
  
  If A1m_Check_If_Attempted('ADD_LOCATION_TO_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('ADD_LOCATION_TO_DB');
  
    Execute Immediate '
    CREATE OR REPLACE PROCEDURE ADD_LOCATION_TO_DB(
                                       pLocCode VARCHAR2,
                                       pMinQty NUMBER,
                                       pMaxQty NUMBER) AS

    begin
            dbms_output.put_line( ''DUMMY PROCEDURE'');
    End;
    ';

  End If; 


-- PART 3


  If A1m_Check_If_Attempted('ADD_LOCATION_TO_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('ADD_LOCATION_TO_DB');
  
    Execute Immediate '
    CREATE OR REPLACE PROCEDURE ADD_LOCATION_TO_DB(
                                       pLocCode VARCHAR2,
                                       pMinQty NUMBER,
                                       pMaxQty NUMBER) AS

    begin
            dbms_output.put_line( ''DUMMY PROCEDURE'');
    End;
    ';

  End If; 


-- PART 4

  If A1m_Check_If_Attempted('ADD_COMPLEX_SALE_TO_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('ADD_COMPLEX_SALE_TO_DB');
  
    Execute Immediate '
    Create Or Replace Procedure ADD_COMPLEX_SALE_TO_DB(
                                  Pcustid Customer.Custid%Type,
                                  Pprodid Product.Prodid%TYPE,
                                  Pqty Sale.Qty%TYPE,
                                  Pdate Varchar2
                                  ) As
                                  

    begin
            dbms_output.put_line( ''DUMMY PROCEDURE'');
    End;
    ';

  End If; 
  
   If A1m_Check_If_Attempted('GET_ALLSALES_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('GET_ALLSALES_FROM_DB');
  
    Execute Immediate '
    create or replace function GET_ALLSALES_FROM_DB return sys_refcursor as
      Vcur Sys_Refcursor;
    begin
      OPEN VcUR FOR SELECT * FROM SALE WHERE SALEID = 50000;
      RETURN VCUR;
    exception
      WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
    End; ';

  End If;  
  
  
  If A1m_Check_If_Attempted('COUNT_PRODUCT_SALES_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('COUNT_PRODUCT_SALES_FROM_DB');
  
    Execute Immediate '
    Create Or Replace Function Count_Product_Sales_From_Db(
                                                  Pdays Integer
                                                  ) return integer AS
    
    BEGIN
      -- DUMMY FUNCTION
      RETURN 999999999999999;
    END;
    ';

  End If; 
  


 -- PART 5 
 
 
  If A1m_Check_If_Attempted('DELETE_SALE_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('DELETE_SALE_FROM_DB');
  
    Execute Immediate '
    Create Or Replace Function Delete_Sale_From_Db Return Number As
    
    BEGIN
      -- DUMMY FUNCTION
      RETURN 999999999999999;
    END;
    ';

  End If; 
  
  
  If A1m_Check_If_Attempted('DELETE_ALL_SALES_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('DELETE_ALL_SALES_FROM_DB');
  
    Execute Immediate '
  CREATE OR REPLACE PROCEDURE DELETE_ALL_SALES_FROM_DB AS

    begin
            dbms_output.put_line( ''DUMMY PROCEDURE'');
    End;
    ';

  End If; 
  
  

-- TASK 6

  If A1m_Check_If_Attempted('DELETE_CUSTOMER') = False Then

    Insert Into Not_Attempted (Fname) Values ('DELETE_CUSTOMER');
  
    Execute Immediate '
    create or replace procedure delete_customer(
                                        Pcustid Customer.Custid%Type
                                        ) as
    begin
            dbms_output.put_line( ''DUMMY PROCEDURE'');
    End;
    ';

  End If; 
  
  
  
  If A1m_Check_If_Attempted('DELETE_PROD_FROM_DB') = False Then

    Insert Into Not_Attempted (Fname) Values ('DELETE_PROD_FROM_DB');
  
    Execute Immediate '
    create or replace procedure delete_prod_from_db(
                                        pprodid product.prodid%type
                                        ) as

    begin
            dbms_output.put_line( ''DUMMY PROCEDURE'');
    End;
    ';

  End If; 


End;
/


